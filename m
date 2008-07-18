From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: Debugging new HW XOR engine driver
Date: Thu, 17 Jul 2008 23:55:45 -0700 (PDT)
Message-ID: <577337.58175.qm@web81301.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I modified ops_complete_write() to compare HW XOR calculations with SW XOR . I am not sure if xor_dest is still has the result XOR at this point. But this compare is failing every time. This doesn't seem to be right of checking XOR correctness. 

Do you have any inputs on how should I check the XOR result.


static void ops_complete_write(void *stripe_head_ref)
{       
        struct stripe_head *sh = stripe_head_ref;                                                       
        struct stripe_queue *sq = sh->sq;                                                               
        int disks = sq->disks, i;                                                                       
        int pd_idx = sq->pd_idx;
        int qd_idx = (sq->raid_conf->level != 6) ? -1 :                                                 
                raid6_next_disk(pd_idx, disks);                                                         
        
        pr_debug("%s: stripe %llu\n", __FUNCTION__,                                                     
                (unsigned long long)sh->sector);                                                        
#if 1 /*marri  test start*/
        struct page *pg;                                                                                
        char *a,*b;
        //int disks = sh->sq->disks;
        struct page *xor_srcs[disks];                                                                   
        int target = sh->ops.target;
        struct r5dev *tgt = &sh->dev[target];                                                           
        struct page *xor_dest = tgt->page;                                                              
        int count = 0;                                                                                  
        int dcnt = 0;                                                                                   
        int j = 0;                                                                                      
        
        for (j = disks; j--; )
                if (j != target)
                        xor_srcs[count++] = sh->dev[j].page;                                            
        
        pg = alloc_page(GFP_KERNEL);                                                                    
        if(!pg) 
                goto no_cmp;
        a = page_address(pg);
        xor_blocks(disks,STRIPE_SIZE,a,(void **)xor_srcs);                                              
        
        b = page_address(xor_dest);
        if((memcmp(b,a,PAGE_SIZE) != 0x0))
                printk(KERN_ERR"Mem compare fialed at \n");                                             
        else {  
                if(mfdcr(0x61) == 0xfee7) {
                        for(dcnt = 0; dcnt < PAGE_SIZE; dcnt+=0x4) 
                                printk("HW = 0x%x SW = 0x%x",*(u32 *)(b + dcnt),*(u32 *)(a + dcnt));    
                }                                                                                       
        }
        if(pg)
        __free_page(pg);                                                                                
no_cmp: 
        if(0)   
                *a = NULL;                                                                              

#endif  /* marri test end */                                                                                                
        
        for (i = disks; i--; ) {
                struct r5dev *dev = &sh->dev[i];
                struct r5_queue_dev *dev_q = &sq->dev[i];                                               
                
                if (dev_q->written || i == pd_idx || i == qd_idx)                                       
                        set_bit(R5_UPTODATE, &dev->flags);                                              
        }                                                                                               

        set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
        set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);

        set_bit(STRIPE_HANDLE, &sh->state);
        release_stripe(sh);
}

Thanks,
Marri



----- Original Message ----
From: Dan Williams <dan.j.williams@intel.com>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: thomas62186218@aol.com; linux-raid@vger.kernel.org
Sent: Tuesday, July 15, 2008 11:48:46 PM
Subject: Re: Debugging new HW XOR engine driver

On Tue, Jul 15, 2008 at 3:52 PM, tirumalareddy marri
<tirumalareddymarri@yahoo.com> wrote:
> I am able to create a disk size of 40MB and mount it(mkfs.ext3 -b 4096 /dev/md0 10000). I was able to copy files to this mounted disk and read them back. If I increased the size more than 40MB file system if failing to mount.
>   Is it possible that data I have read/write was in page cache and never really written to Hard Disks  ?

What does the corruption look like?  Does it seem to be wrong data or
stale data?

> Is it safe to say RAID-5 is partially working ?

Without more information this sounds like the hw-xor driver is broken.
What kernel version are you developing against?  You may want to take
a look at the dmatest client in async_tx/next [1].  It currently only
supports copy tests, but should exercise your driver's descriptor
processing routines.  When I tracked down bugs in iop-adma I used
raid5 as the test client and modified the kernel to do data
verification after each calculation in the ops_complete_* routines.
This requires userspace to use a predictable data pattern when writing
to the array.

--
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=next
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

