From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Removing a Raid Partition? How-to?
Date: Wed, 15 May 2002 09:00:00 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15585.38640.715130.181439@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.31L.02.0205141604120.12302-100000@linux2.gl.umb
 c.edu>
	<5.1.0.14.0.20020514171826.01f64070@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Hill on Tuesday May 14
To: Jeff Hill <jhill@hronline.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 14, jhill@hronline.com wrote:
> Oddly, it seems I can't change the partitions of a previously formatted 
> raid disk.  When I use fdisk to repartition a drive previously formatted 
> with the type set to Linux autoraid detect, I reboot only to find the 
> autoraid partitions are still there. I have stopped the raid devices, but 
> it seems I can't kill the persistent superblock. I tried reformatting with 
> mke2fs and of course that failed to do the trick.

If you change the partition type to something else, it really
shouldn't autodetect any more.. Do you have an /etc/raidtab describing
the array, and is raidstart being run at boottime by some script?

In any case, 
   mdadm --zero-superblock /dev/hda1

will zero the md/raid superblock on /dev/hda1

NeilBrown
