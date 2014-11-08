// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>
// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
                panic("faulting access not a write faulting access not to a copy-on-write page");
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
                panic("panic in pgfault:sys_page_alloc: %e",r);
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
                panic("panic in pgfault:sys_page_map:%e",r);

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
                panic("panic in pgfault:sys_page_unmap:%e",r);
	
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	// LAB 4: Your code here.
	uint64_t addr;
	uint64_t pte;
	r=PTE_COW|PTE_P|PTE_U;
	addr = (uint64_t) (pn * PGSIZE);
	pte=uvpt[pn];
	if(((pte & PTE_W) || (pte & PTE_COW))) 
	{
		r = sys_page_map(0, (void *)addr, envid, (void *)addr, PTE_P|PTE_U|PTE_COW); 
		if(r<0) 
	 		panic("duppage:sys_page_map"); 
		r = sys_page_map(envid, (void*)addr, 0, (void*)addr, PTE_P|PTE_U|PTE_COW);
    		if (r<0) 
      			panic("duppage:sys_page_map");

	}
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
   	if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) 
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
	if (r < 0)
    		panic("in fork, sys_page_alloc error");
	int a,b,c,d, e = 0, f = 0;
	for(a=0;a<VPML4E(UTOP);a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0; b<VPDPE(UTOP); b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0; c< NPDENTRIES; c++, e++)
					{
						if(uvpd[e] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++, f++)
							{
								if((uvpt[f] & PTE_P) && (f != VPN(UXSTACKTOP-PGSIZE)))
									duppage(envid,f);
							}
						}
						else {
							f = (e+1)*NPTENTRIES;
						}
					}
				}
				else {
					e = (b+1) * NPDENTRIES;
				}
			}
		}
	}


	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
	if(r<0)
		panic("in fork, sys_page_upcall error");
	r = sys_env_set_status(envid,ENV_RUNNABLE);
	if(r<0)
                panic("in fork, sys_env_set_status error");
	return envid;
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
