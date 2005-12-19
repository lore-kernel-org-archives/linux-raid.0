From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Mon, 19 Dec 2005 11:34:06 +0100
Message-ID: <005d01c60487$cc198b40$0400a8c0@dcccs>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs><17300.56329.638969.509384@cse.unsw.edu.au><004201c5f9fe$50cc41a0$0400a8c0@dcccs><17300.58327.193597.248431@cse.unsw.edu.au><035b01c5fc4b$416c98f0$0400a8c0@dcccs><17304.50474.390938.734714@cse.unsw.edu.au><001101c5fc75$a28cb230$0400a8c0@dcccs><17305.3277.821697.223406@cse.unsw.edu.au><000001c5eb50$4e6fada0$a700a8c0@dcccs> <17318.1401.296396.667001@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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
Sent: Monday, December 19, 2005 1:57 AM
Subject: Re: RAID5 resync question BUGREPORT!


> On Thursday November 17, djani22@dynamicweb.hu wrote:
> > Hello,
> >
> > Now i trying the patch....
> >
> > [root@st-0001 root]# mdadm -G --bitmap=/raid.bm /dev/md0
> > mdadm: Warning - bitmaps created on this kernel are not portable
> >   between different architectured.  Consider upgrading the Linux kernel.
> > mdadm: Cannot set bitmap file for /dev/md0: Cannot allocate memory
>
> How big is your array?

     Raid Level : raid5
     Array Size : 1953583360 (1863.08 GiB 2000.47 GB)
    Device Size : 195358336 (186.31 GiB 200.05 GB)


> The default bitmap-chunk-size when the bitmap is in a file is 4K, this
> makes a very large bitmap on a large array.

Yes, and if i can see correctly, it makes overflow.

> Try a larger bitmap-chunk size e.g.
>
>    mdadm -G --bitmap-chunk=256 --bitmap=/raid.bm /dev/md0

I think it is still uncompleted!

[root@st-0001 /]# mdadm -G --bitmap-chunk=256 --bitmap=/raid.bm /dev/md0
mdadm: Warning - bitmaps created on this kernel are not portable
  between different architectured.  Consider upgrading the Linux kernel.
Segmentation fault
[root@st-0001 /]#

And the raid layer is stopped.
(The nbd-server stops to serving, and the cat /proc/mdstat is hangs too.
i try to sync, and
echo b >/proc/sysrq-trigger
After reboot, everything is back to normal.)

This generates one 96000 byte /raid.bm.

(Anyway i think the --bitmap-chunk option is neccessary to be automaticaly
generated.)


> > [root@st-0001 root]# mdadm -X /dev/md0
>
> This usage is only appropriate for arrays with internal bitmaps (I
> should get mdadm to check that..).

Is there a way to check external bitmaps?

> >
> > And now what? :-)
>
> Either create an 'internal' bitmap, or choose a --bitmap-chunk size
> that is larger.

First you sad, the space to the internal bitmap is only 64K.
My first bitmap file is ~4MB, and with --bitmap-chunk=256 option still 96000
Byte.

I don't think so... :-)

I am affraid to overwrite an existing data.

Cheers,
Janos


>
> Thanks for the report.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

