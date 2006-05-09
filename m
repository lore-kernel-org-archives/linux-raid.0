From: CaT <cat@zip.com.au>
Subject: Re: strange RAID5 problem
Date: Tue, 9 May 2006 16:12:45 +1000
Message-ID: <20060509061245.GA4776@zip.com.au>
References: <4460290C.50202@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4460290C.50202@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Mon, May 08, 2006 at 11:30:52PM -0600, Maurice Hilarius wrote:
> [root@box ~]# mdadm
> --assemble /dev/md3 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1
> /dev/sdv1 /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1
> /dev/sdac1 /dev/sdad1 /dev/sdae1 /dev/sdaf1
> mdadm: superblock on /dev/sdw1 doesn't match others - assembly aborted

Have you tried zeroing the superblock with

mdadm --misc --zero-superblock /dev/sdw1

and then adding it in?

> [root@box ~]# mount /dev/md3 /all/boxw16/
> /dev/md3: Invalid argument
> mount: /dev/md3: can't read superblock

Wow that looks messy. ummm. about the only thing I can think of is
failing /dev/sdw1 and removing it (I know it says it's not there
but...)

Also, not biggest expert on raid around here. ;)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
