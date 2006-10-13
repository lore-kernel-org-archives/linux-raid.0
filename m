From: Neil Brown <neilb@suse.de>
Subject: Re: BUGS: internal bitmap during array create
Date: Fri, 13 Oct 2006 12:48:10 +1000
Message-ID: <17710.65130.194296.801803@cse.unsw.edu.au>
References: <452D500D.6000203@ilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eli Stair on Wednesday October 11
Sender: linux-raid-owner@vger.kernel.org
To: Eli Stair <estair@ilm.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday October 11, estair@ilm.com wrote:
> 
> After realizing my stupid error in specifying the bitmap during array 
> creation, I've triggered a couple of 100% repeatable bugs with this 
> scenario.
> 
> 
> BUG 1)
....
> 
> 
> Strangely, whatever the underlying cause is, ext3 seems immune (at least 
> in brief testing) to this.  I can create and mount an ext3 filesystem on 
> top of the array that xfs dies trying to mount.
> 
> In the case where the array is created with bitmap at build time, if I 
> wait until resync is completed, do a 'mdadm -Gb none' followed by 'mdadm 
> -Gb internal', I can then safely create the XFS filesystem and mount
> it.

Can you get me the output of
   mdadm -X some-component-device
both after the creation with a bitmap, and after the bitmap has been
hot-removed and hot-added.
Just for good measure, include the "mdadm -E" output at the same
times.

> 
> BUG 2)
> 
> Another bitmap failure during create time:  MDADM dies with an error 
> after creating the array, when it tries to assemble it, with an 
> external-file bitmap (on ext3):
> 
> 
>      [root@gtmp01 GTMP]# mdadm -C /dev/md0 -f --chunk=512 --level=10 
> -n14 -po2 -e1.2 -bESC[1P^M[root@gtmp01 GTMP]# mdadm -C /dev/md0 -f 
> --chunk=512 --level=10 -n14 -po2 -e1.2 -b/var/tmp/bitmap /dev/mapper/mpath*
>      mdadm: RUN_ARRAY failed: Cannot allocate memory
>      mdadm: stopped /dev/md0

I thought I had fixed this in 2.5, but on reflection that might not
fixed it for 64bit hosts. Can you try explicitly setting the
--bitmap-chunk size such that there will be fewer than 1,000,000
chunks?

NeilBrown
