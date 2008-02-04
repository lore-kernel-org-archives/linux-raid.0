From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.4 : How i can check out current status of reshaping ?
Date: Tue, 5 Feb 2008 09:48:33 +1100
Message-ID: <18343.38465.112723.66522@notabene.brown>
References: <79188012.20080204070802@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas-Sokov on Monday February 4
Sender: linux-raid-owner@vger.kernel.org
To: Andreas-Sokov <andre.s@j8.com.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 4, andre.s@j8.com.ru wrote:
> 
> root@raid01:/# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty]
> md1 : active raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
>       1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
> 
> unused devices: <none>
> 
> ##############################################################################
> But how i can see the status of reshaping ?
> Is it reshaped realy ? or may be just hang up ? or may be mdadm nothing do not give in
> general ?
> How long wait when reshaping will finish ?
> ##############################################################################
> 

The reshape hasn't restarted.

Did you do that "mdadm -w /dev/md1" like I suggested?  If so, what
happened?

Possibly you tried mounting the filesystem before trying the "mdadm
-w".  There seems to be a bug such that doing this would cause the
reshape not to restart, and "mdadm -w" would not help any more.

I suggest you:

  echo 0 > /sys/module/md_mod/parameters/start_ro

stop the array 
  mdadm -S /dev/md1
(after unmounting if necessary).

Then assemble the array again.
Then
  mdadm -w /dev/md1

just to be sure.

If this doesn't work, please report exactly what you did, exactly what
message you got and exactly where message appeared in the kernel log.

NeilBrown
