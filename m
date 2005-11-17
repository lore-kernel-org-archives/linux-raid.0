From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Thu, 17 Nov 2005 02:09:20 +0100
Message-ID: <000001c5eb50$4e6fada0$a700a8c0@dcccs>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs><17300.56329.638969.509384@cse.unsw.edu.au><004201c5f9fe$50cc41a0$0400a8c0@dcccs><17300.58327.193597.248431@cse.unsw.edu.au><035b01c5fc4b$416c98f0$0400a8c0@dcccs><17304.50474.390938.734714@cse.unsw.edu.au><001101c5fc75$a28cb230$0400a8c0@dcccs> <17305.3277.821697.223406@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Now i trying the patch....

[root@st-0001 root]# mdadm -G --bitmap=/raid.bm /dev/md0
mdadm: Warning - bitmaps created on this kernel are not portable
  between different architectured.  Consider upgrading the Linux kernel.
mdadm: Cannot set bitmap file for /dev/md0: Cannot allocate memory
[root@st-0001 root]# free
             total       used       free     shared    buffers     cached
Mem:       2073152      75036    1998116          0          4      29304
-/+ buffers/cache:      45728    2027424
Swap:            0          0          0
[root@st-0001 root]# mdadm -X /dev/md0
mdadm: WARNING: bitmap file is not large enough for array size
2641363663419644516!

        Filename : /dev/md0
           Magic : a799d766
mdadm: invalid bitmap magic 0xa799d766, the bitmap file appears to be
corrupted
         Version : -91455910
mdadm: unknown bitmap version -91455910, either the bitmap file is corrupted
or you need to upgrade your tools
[root@st-0001 root]#

And now what? :-)

Cheers,
Janos


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Friday, December 09, 2005 5:49 AM
Subject: Re: RAID5 resync question BUGREPORT!


> On Friday December 9, djani22@dynamicweb.hu wrote:
> > Hi,
> >
> > After i get this on one of my disk node, imediately send this letter,
and go
> > to the hosting company, to see, is any message on the screen.
> > But unfortunately nothing what i found.
> > simple freeze.
> > no message, no ping, no num lock!
> >
> > The full message of  the node next reboot is here:
> > http://download.netcenter.hu/bughunt/20051209/boot.log
>
> Ahh.... Ok, I know the problem.
> I had originally only tested bitmaps for raid5 and raid6 on a
> single-processor machine.  When you try it on an SMP machine you get a
> deadlock.
> The following patch - which will be in 2.6.15 - fixes the problem.
>
> Thanks for your testing.
>
> NeilBrown
>
> -------------------------------
> Fix locking problem in r5/r6
>
> bitmap_unplug actually writes data (bits) to storage, so we
> shouldn't be holding a spinlock...
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./drivers/md/raid5.c     |    2 ++
>  ./drivers/md/raid6main.c |    2 ++
>  2 files changed, 4 insertions(+)
>
> diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
> --- ./drivers/md/raid5.c 2005-12-06 11:06:53.000000000 +1100
> +++ ./drivers/md/raid5.c~current~ 2005-12-06 11:07:10.000000000 +1100
> @@ -1704,7 +1704,9 @@ static void raid5d (mddev_t *mddev)
>
>   if (conf->seq_flush - conf->seq_write > 0) {
>   int seq = conf->seq_flush;
> + spin_unlock_irq(&conf->device_lock);
>   bitmap_unplug(mddev->bitmap);
> + spin_lock_irq(&conf->device_lock);
>   conf->seq_write = seq;
>   activate_bit_delay(conf);
>   }
>
> diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
> --- ./drivers/md/raid6main.c 2005-12-06 11:06:53.000000000 +1100
> +++ ./drivers/md/raid6main.c~current~ 2005-12-06 11:07:10.000000000 +1100
> @@ -1784,7 +1784,9 @@ static void raid6d (mddev_t *mddev)
>
>   if (conf->seq_flush - conf->seq_write > 0) {
>   int seq = conf->seq_flush;
> + spin_unlock_irq(&conf->device_lock);
>   bitmap_unplug(mddev->bitmap);
> + spin_lock_irq(&conf->device_lock);
>   conf->seq_write = seq;
>   activate_bit_delay(conf);
>   }

