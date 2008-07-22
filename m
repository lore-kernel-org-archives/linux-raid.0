From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: (SOLOVED)Debugging new HW XOR engine driver
Date: Mon, 21 Jul 2008 17:06:18 -0700 (PDT)
Message-ID: <518193.94831.qm@web81308.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After lot of debugging I found the=A0 HW accelerated XOR is working fin=
e . It is actually SATA Hard Disk on SATA PCI-E connector is the culpri=
t. There=A0were IO errors happening which lead to Data corruption durin=
g RAID-5.=A0Initially =A0I did not suspect Hard Disk=A0as RAID-0 was wo=
rking fine.
=A0Now I am having READ performance issues(27MBps). Write performance i=
s ok(29MBps). Any inputs would be great help.
Thanks and Regards,
Marri


----- Original Message ----
=46rom: tirumalareddy marri <tirumalareddymarri@yahoo.com>
To: linux-raid@vger.kernel.org
Sent: Thursday, July 17, 2008 11:55:45 PM
Subject: Re: Debugging new HW XOR engine driver

I modified ops_complete_write() to compare HW XOR calculations with SW =
XOR . I am not sure if xor_dest is still has the result XOR at this poi=
nt. But this compare is failing every time. This doesn't seem to be rig=
ht of checking XOR correctness.=20

Do you have any inputs on how should I check the XOR result.


static void ops_complete_write(void *stripe_head_ref)
{=A0 =A0 =A0=20
=A0 =A0 =A0 =A0 struct stripe_head *sh =3D stripe_head_ref;=A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 struct stripe_queue *sq =3D sh->sq;=A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 int disks =3D sq->disks, i;=A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 int pd_idx =3D sq->pd_idx;
=A0 =A0 =A0 =A0 int qd_idx =3D (sq->raid_conf->level !=3D 6) ? -1 :=A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 raid6_next_disk(pd_idx, disks);=A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 pr_debug("%s: stripe %llu\n", __FUNCTION__,=A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)sh->sector);=A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
#if 1 /*marri=A0 test start*/
=A0 =A0 =A0 =A0 struct page *pg;=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 char *a,*b;
=A0 =A0 =A0 =A0 //int disks =3D sh->sq->disks;
=A0 =A0 =A0 =A0 struct page *xor_srcs[disks];=A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 int target =3D sh->ops.target;
=A0 =A0 =A0 =A0 struct r5dev *tgt =3D &sh->dev[target];=A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 struct page *xor_dest =3D tgt->page;=A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 int count =3D 0;=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 int dcnt =3D 0;=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 int j =3D 0;=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 for (j =3D disks; j--; )
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (j !=3D target)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xor_srcs[count++] =3D s=
h->dev[j].page;=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 pg =3D alloc_page(GFP_KERNEL);=A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 if(!pg)=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto no_cmp;
=A0 =A0 =A0 =A0 a =3D page_address(pg);
=A0 =A0 =A0 =A0 xor_blocks(disks,STRIPE_SIZE,a,(void **)xor_srcs);=A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 b =3D page_address(xor_dest);
=A0 =A0 =A0 =A0 if((memcmp(b,a,PAGE_SIZE) !=3D 0x0))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR"Mem compare fialed at \=
n");=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 else {=A0=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(mfdcr(0x61) =3D=3D 0xfee7) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for(dcnt =3D 0; dcnt < =
PAGE_SIZE; dcnt+=3D0x4)=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(=
"HW =3D 0x%x SW =3D 0x%x",*(u32 *)(b + dcnt),*(u32 *)(a + dcnt));=A0 =A0=
=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 }
=A0 =A0 =A0 =A0 if(pg)
=A0 =A0 =A0 =A0 __free_page(pg);=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
no_cmp:=20
=A0 =A0 =A0 =A0 if(0)=A0=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *a =3D NULL;=A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20

#endif=A0 /* marri test end */=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0=20
=A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 for (i =3D disks; i--; ) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct r5dev *dev =3D &sh->dev[i];
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct r5_queue_dev *dev_q =3D &sq->dev=
[i];=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev_q->written || i =3D=3D pd_idx |=
| i =3D=3D qd_idx)=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(R5_UPTODATE, &d=
ev->flags);=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20
=A0 =A0 =A0 =A0 }=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=20

=A0 =A0 =A0 =A0 set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
=A0 =A0 =A0 =A0 set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);

=A0 =A0 =A0 =A0 set_bit(STRIPE_HANDLE, &sh->state);
=A0 =A0 =A0 =A0 release_stripe(sh);
}

Thanks,
Marri



----- Original Message ----
=46rom: Dan Williams <dan.j.williams@intel.com>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: thomas62186218@aol.com; linux-raid@vger.kernel.org
Sent: Tuesday, July 15, 2008 11:48:46 PM
Subject: Re: Debugging new HW XOR engine driver

On Tue, Jul 15, 2008 at 3:52 PM, tirumalareddy marri
<tirumalareddymarri@yahoo.com> wrote:
> I am able to create a disk size of 40MB and mount it(mkfs.ext3 -b 409=
6 /dev/md0 10000). I was able to copy files to this mounted disk and re=
ad them back. If I increased the size more than 40MB file system if fai=
ling to mount.
>=A0 Is it possible that data I have read/write was in page cache and n=
ever really written to Hard Disks=A0 ?

What does the corruption look like?=A0 Does it seem to be wrong data or
stale data?

> Is it safe to say RAID-5 is partially working ?

Without more information this sounds like the hw-xor driver is broken.
What kernel version are you developing against?=A0 You may want to take
a look at the dmatest client in async_tx/next [1].=A0 It currently only
supports copy tests, but should exercise your driver's descriptor
processing routines.=A0 When I tracked down bugs in iop-adma I used
raid5 as the test client and modified the kernel to do data
verification after each calculation in the ops_complete_* routines.
This requires userspace to use a predictable data pattern when writing
to the array.

--
Dan

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/async_tx.git;a=3Ds=
hortlog;h=3Dnext
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
