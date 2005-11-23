From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Wed, 23 Nov 2005 10:38:44 +0100
Message-ID: <007a01c5f012$895517e0$a700a8c0@dcccs>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs><17300.56329.638969.509384@cse.unsw.edu.au><004201c5f9fe$50cc41a0$0400a8c0@dcccs><17300.58327.193597.248431@cse.unsw.edu.au><035b01c5fc4b$416c98f0$0400a8c0@dcccs><17304.50474.390938.734714@cse.unsw.edu.au><001101c5fc75$a28cb230$0400a8c0@dcccs><17305.3277.821697.223406@cse.unsw.edu.au><000001c5eb50$4e6fada0$a700a8c0@dcccs><17318.1401.296396.667001@cse.unsw.edu.au><005d01c60487$cc198b40$0400a8c0@dcccs> <17322.12175.915592.878387@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, December 22, 2005 5:46 AM
Subject: Re: RAID5 resync question BUGREPORT!


> On Monday December 19, djani22@dynamicweb.hu wrote:
> > ----- Original Message ----- 
> > From: "Neil Brown" <neilb@suse.de>
> > To: "JaniD++" <djani22@dynamicweb.hu>
> > Cc: <linux-raid@vger.kernel.org>
> > Sent: Monday, December 19, 2005 1:57 AM
> > Subject: Re: RAID5 resync question BUGREPORT!
> > >
> > > How big is your array?
> >
> >      Raid Level : raid5
> >      Array Size : 1953583360 (1863.08 GiB 2000.47 GB)
> >     Device Size : 195358336 (186.31 GiB 200.05 GB)
> >
> >
> > > The default bitmap-chunk-size when the bitmap is in a file is 4K, this
> > > makes a very large bitmap on a large array.
>
> Hmmm The bitmap chunks are in the device space rather than the array
> space. So 4K chunks in 186GiB is 48million chunks, so 48million bits.
> 8*4096 bits per page, so 1490 pages, which is a lot, and maybe a
> waste, but you should be able to allocate 4.5Meg...
>
> But there is a table which holds pointers to these pages.
> 4 bytes per pointer (8 on a 64bit machine) so 6K or 12K for the table.
> Allocating anything bigger than 4K can be a problem, so that is
> presumably the limit you hit.
>
> The max the table size should be is 4K, which is 1024 pages (on a
> 32bit machine), which is 33 million bits.  So we shouldn't allow more
> than 33million (33554432 actually) chunks.
> On you array, that would be 5.8K, so 8K chunks should be ok, unless
> you have a 64bit machine, then 16K chunks.
> Still that is wasting a lot of space.

My system is currently running on i386, 32.
I can see, the 2TB array is usually hit some limits. :-)
My first idea was the variables phisical size. (eg: int:32768, double 65535,
etc...)
Did you chech that? :-)

>
> >
> > Yes, and if i can see correctly, it makes overflow.
> >
> > > Try a larger bitmap-chunk size e.g.
> > >
> > >    mdadm -G --bitmap-chunk=256 --bitmap=/raid.bm /dev/md0
> >
> > I think it is still uncompleted!
> >
> > [root@st-0001 /]# mdadm -G --bitmap-chunk=256 --bitmap=/raid.bm /dev/md0
> > mdadm: Warning - bitmaps created on this kernel are not portable
> >   between different architectured.  Consider upgrading the Linux kernel.
> > Segmentation fault
>
> Oh dear.... There should have been an 'oops' message in the kernel
> logs.  Can you post it.

Yes, you have right!

If i think correclty, the problem is the live bitmap file on NFS. :-)
(i am a really good tester! :-D)


Dec 19 10:58:37 st-0001 kernel: md0: bitmap file is out of date (0 <
82198273) -- forcing full recovery
Dec 19 10:58:37 st-0001 kernel: md0: bitmap file is out of date, doing full
recovery
Dec 19 10:58:37 st-0001 kernel: Unable to handle kernel NULL pointer
dereference at virtual address 00000078
Dec 19 10:58:38 st-0001 kernel:  printing eip:
Dec 19 10:58:38 st-0001 kernel: c0213524
Dec 19 10:58:38 st-0001 kernel: *pde = 00000000
Dec 19 10:58:38 st-0001 kernel: Oops: 0000 [#1]
Dec 19 10:58:38 st-0001 kernel: SMP
Dec 19 10:58:38 st-0001 kernel: Modules linked in: netconsole
Dec 19 10:58:38 st-0001 kernel: CPU:    0
Dec 19 10:58:38 st-0001 kernel: EIP:    0060:[<c0213524>]    Not tainted VLI
Dec 19 10:58:38 st-0001 kernel: EFLAGS: 00010292   (2.6.14.2-NBDFIX)
Dec 19 10:58:38 st-0001 kernel: EIP is at nfs_flush_incompatible+0xf/0x8d
Dec 19 10:58:38 st-0001
Dec 19 10:58:38 st-0001 kernel: eax: 00000000   ebx: 00000f00   ecx:
00000000   edx: 00000282
Dec 19 10:58:38 st-0001 kernel: esi: 00000001   edi: c1fcaf40   ebp:
f7dc7500   esp: e2281d7c
Dec 19 10:58:38 st-0001 kernel: ds: 007b   es: 007b   ss: 0068
Dec 19 10:58:38 st-0001 kernel: Process mdadm (pid: 30771,
threadinfo=e2280000 task=f6f28540)
Dec 19 10:58:38 st-0001 kernel: Stack: 00000000 00000282 c014fd3f c1fcaf40
00000060 00000f00 00000001 c1fcaf40
Dec 19 10:58:38 st-0001 kernel:        f7dc7500 c04607e1 00000000 c1fcaf40
00000000 00001000 c1fcaf40 00000f00
Dec 19 10:58:38 st-0001 kernel:        c1fcaf40 ffaa6000 00000000 c04619a7
f7dc7500 c1fcaf40 00000001 00000000
Dec 19 10:58:38 st-0001 kernel: Call Trace:
Dec 19 10:58:38 st-0001 kernel:  [<c014fd3f>] page_address+0x8e/0x94
Dec 19 10:58:38 st-0001 kernel:  [<c04607e1>] write_page+0x5b/0x15d
Dec 19 10:58:38 st-0001 kernel:  [<c04619a7>]
bitmap_init_from_disk+0x3eb/0x4df
Dec 19 10:58:38 st-0001 kernel:  [<c0462b79>] bitmap_create+0x1dc/0x2d3
Dec 19 10:58:38 st-0001 kernel:  [<c045d579>] set_bitmap_file+0x68/0x19f
Dec 19 10:58:38 st-0001 kernel:  [<c045e0f6>] md_ioctl+0x456/0x678
Dec 19 10:58:38 st-0001 kernel:  [<c04f7640>]
rpcauth_lookup_credcache+0xe3/0x1cb
Dec 19 10:58:38 st-0001 kernel:  [<c04f7781>] rpcauth_lookupcred+0x59/0x95
Dec 19 10:58:38 st-0001 kernel:  [<c020c240>]
nfs_file_set_open_context+0x29/0x4b
Dec 19 10:58:38 st-0001 kernel:  [<c03656e8>] blkdev_driver_ioctl+0x6b/0x80
Dec 19 10:58:38 st-0001 kernel:  [<c0365824>] blkdev_ioctl+0x127/0x19e
Dec 19 10:58:38 st-0001 kernel:  [<c016a2fb>] block_ioctl+0x2b/0x2f
Dec 19 10:58:38 st-0001 kernel:  [<c01745ed>] do_ioctl+0x2d/0x81
Dec 19 10:58:38 st-0001 kernel:  [<c01747c6>] vfs_ioctl+0x5a/0x1ef
Dec 19 10:58:38 st-0001 kernel:  [<c01749ca>] sys_ioctl+0x6f/0x7d
Dec 19 10:58:38 st-0001 kernel:  [<c0102cc3>] sysenter_past_esp+0x54/0x75
Dec 19 10:58:38 st-0001 kernel: Code: 5c 24 14 e9 bb fe ff ff 89 f8 e8 9e 5d
2f 00 89 34 24 e8 a2 f9 ff ff e9 a7 fe ff ff 55 57 56 53 83 ec 14 8b 7c 24
2c 8b 44 24 28 <8b> 40 78 89 44 24 10 8b 47 10 8b 28 8b 47 14 89 44 24 04 89
2c
Dec 19 10:59:54 st-0001 SysRq :
Dec 19 10:59:54 st-0001 Resetting
Dec 19 10:59:54 st-0001 kernel:  <6>SysRq : Resetting


> > (Anyway i think the --bitmap-chunk option is neccessary to be
automaticaly
> > generated.)
>
> Yes... I wonder what the default should be.
> Certainly not more than 33million bits.  Maybe a maximum of 8 million
> (1 megabyte).

(
Generally i cannot understand why it working this way....
When i made this, it should be work in reverse order!
I mean hardcoded [or soft configurable] divisor 64K or 32K [depends on
superblocks free space], for minimal use of space, and system resources, to
rewrite it on all devices!
eg in my system -what usually hits limits- the full resync time on 2TB is 4
hour.
If the resync time can be only 4 hour /32768 = 0.44 sec, it is really good
enough! :-)
)


> > > > [root@st-0001 root]# mdadm -X /dev/md0
> > >
> > > This usage is only appropriate for arrays with internal bitmaps (I
> > > should get mdadm to check that..).
> >
> > Is there a way to check external bitmaps?
>
> mdadm -X /raid.bm
>
> i.e. eXamine the object (device or file) that has the bitmap on it.
> Actually, I don't think 'mdadm -X /dev/md0' is right even for
> 'internal' bitmaps.  It should be 'mdadm -x /dev/sda1' Or whichever
> is a component device.

That sounds good.

>
> >
> > > >
> > > > And now what? :-)
> > >
> > > Either create an 'internal' bitmap, or choose a --bitmap-chunk size
> > > that is larger.
> >
> > First you sad, the space to the internal bitmap is only 64K.
> > My first bitmap file is ~4MB, and with --bitmap-chunk=256 option still
96000
> > Byte.
> >
> > I don't think so... :-)
>
> When using an internal bitmap, mdadm will automatically size the
> bitmap to fit. In your case I think it will choose 512k as the chunk
> size so the bitmap of 48K will fit in the space after the superblock.

Ahh..
Thats what i have talking about. :-)

> >
> > I am affraid to overwrite an existing data.
> >
>
> There is no risk of that.

OK, i trusting in you, and raid! :-)

Thanks,
Janos

>
> NeilBrown
>
> (holidays are coming, so I may not be able to reply further for a
> couple of weeks)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

