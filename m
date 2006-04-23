From: Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: Recovery speed at 1MB/s/device, unable to change
Date: Mon, 24 Apr 2006 01:49:37 +0300
Message-ID: <444C0481.2000408@gmail.com>
References: <444BD3E7.4090601@gmail.com>	<444BF3AC.4090804@gmail.com> <17483.63636.745420.456281@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040908020507010906050906"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17483.63636.745420.456281@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040908020507010906050906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

(resend, prev post missed the list)

Neil Brown wrote:
> On Monday April 24, anssi.hannula@gmail.com wrote:
> 
>># mdadm --grow /dev/md_d1 --raid-devices=3 --backup-file backupfile
>>mdadm: Need to backup 128K of critical section..
>>mdadm: /dev/md_d1: Cannot get array details from sysfs
>>
>>Strace shows that it's trying to access
>>"/sys/block/md_d4/md/component_size".
>>
>>Why is this?
> 
> 
> Because I didn't test my code properly :-(
> 
> Following patch should fix it.
> 

It appears you missed another occurrence (patch attached).

However, it got stuck after
mdadm: Need to backup 128K of critical section..

I did ctrl-c, and according to /proc/mdstat it was successfully
reshaped, nor can I restart the reshape.

But "umount /mnt/test" (/mnt/test is where /dev/md_d1p1 is mounted)
blocks, and this time it becomes unkillable.

/proc/mdstat reports:
md_d1 : active raid5 loop1[1] loop0[0]
      4992 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]


-- 
Anssi Hannula



--------------040908020507010906050906
Content-Type: text/x-patch;
 name="sysfs-minor.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysfs-minor.diff"

--- sysfs.c.old	2006-04-24 01:24:09.000000000 +0300
+++ sysfs.c	2006-04-24 01:33:48.000000000 +0300
@@ -69,7 +69,7 @@
 			sprintf(sra->name, "md%d", minor(stb.st_rdev));
 		else
 			sprintf(sra->name, "md_d%d",
-				minor(stb.st_rdev)/16);
+				minor(stb.st_rdev)/64);
 	} else {
 		if (devnum >= 0)
 			sprintf(sra->name, "md%d", devnum);


--------------040908020507010906050906--
