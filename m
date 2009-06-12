From: Neil Brown <neilb@suse.de>
Subject: Re: Assembly problems with kernel 2.6.30?
Date: Fri, 12 Jun 2009 11:33:10 +1000
Message-ID: <18993.45142.80174.321434@notabene.brown>
References: <20090611072538.GA7841@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Paris on Thursday June 11
Sender: linux-raid-owner@vger.kernel.org
To: Jim Paris <jim@jtan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 11, jim@jtan.com wrote:
> Hi,
> 
> I am running Debian with my root filesystem on /dev/md1.
> At boot, hook scripts in initramfs-tools run:
> 
> mdadm --assemble --scan --run --auto=yes /dev/md1
> 
> with the following /etc/mdadm/mdadm.conf:
> 
> DEVICE partitions
> ARRAY /dev/md0 level=raid1 num-devices=6 UUID=dece84f3:a8f8be71:ea9d9fee:21fd5f90
> ARRAY /dev/md1 level=raid1 num-devices=2 UUID=0598d2ea:f6c0185f:614fa502:109d1a5d
> ARRAY /dev/md2 level=raid5 num-devices=4 UUID=eed65e3878:f4e6e055:198bdcfe:77de48
> 
> For the record:
> /dev/md0 uses /dev/sd[abcdef]1
> /dev/md1 uses /dev/sd[ab]2
> /dev/md2 uses /dev/sd[cdef]2
> 
> On kernel 2.6.27.3, this worked fine.  After upgrading to 2.6.30, the
> initrams failed with the error:
> 
>   mdadm: superblock on /dev/sdc2 doesn't match others - assembly aborted
> 
> The solution was to change the /etc/mdadm/mdadm.conf to specifically
> list the metadata format:
> 
> DEVICE partitions
> ARRAY /dev/md0 level=raid1 num-devices=6 UUID=dece84f3:a8f8be71:ea9d9fee:21fd5f90
> ARRAY /dev/md1 level=raid1 num-devices=2 UUID=0598d2ea:f6c0185f:614fa502:109d1a5d
> ARRAY /dev/md2 level=raid5 metadata=1.0 num-devices=4 UUID=eed65e3878:f4e6e055:198bdcfe:77de48
> 
> This was tested with Debian mdadm packages 2.6.7.2-1 and 2.6.9-3 -- no
> difference.
> 
> So, is this a bug?  Kernel or mdadm?  If user error, why did it work
> before?  Also, why does the metadata on /dev/md2 matter for assembling
> /dev/md1?

It looks at first like it might be an mdadm problem - I cannot imagine
a kernel bug doing that.  But you say it only happened with an update
to 2.6.30, which I cannot explain.
Can you:
 
 for m in 0.90 1.0 1.1 1.2
 do mdadm -E -e $m /dev/sd[cdef]2
 done

and report the result?

Thanks,
NeilBrown
