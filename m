From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid10 centos5 vs. centos6 300% worse random write performance
Date: Sun, 28 Jul 2013 00:46:28 -0500
Message-ID: <51F4B034.3040801@hardwarefreak.com>
References: <loom.20130725T120703-146@post.gmane.org> <alpine.DEB.2.00.1307251338050.8891@uplift.swm.pp.se> <loom.20130727T221553-552@post.gmane.org> <CALFpzo71sjK6Cd=jZ_iQG8rRk5TatGsJ5FznD75ayTm1A5kH-g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo71sjK6Cd=jZ_iQG8rRk5TatGsJ5FznD75ayTm1A5kH-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: Wes <wt75@gazeta.pl>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/27/2013 4:01 PM, Marcus Sorensen wrote:
> Seekmark is very simple. It opens a block device with O_RDWR and
> O_SYNC, divides the disk into block_size chunks, spawns a bunch of
> threads, and each one chooses a random block, seeks there, writes,
> then chooses another, seeks there, writes, etc.  There shouldn't be
> any write barrier issue, since there's no filesystem involved. You can
> also point it at a file on a filesystem and it will do the same with
> that file, the O_SYNC *should* flush on every write.
> 
> There could be IO scheduler differences between the kernels.

~$ cat /sys/block/sda/queue/scheduler
[CFQ] noop deadline

Wes, yours will show CFQ probably as the default on RHEL/CentOS.  You'll
want deadline for best seek and all around performance.  So:

~$ echo deadline > /sys/block/sda/queue/scheduler

Add that to an init script or cron entry so it sets on every boot.

Also, make sure NCQ is working on each drive.  If it is, try disabling
it.  Look in dmesg for 4 lines like this with (depth 31/32), or at least
not zero for the first number.  Post the output for us to see.

ataX.00: xxxxxxxxx sectors, multi 16: LBA48 NCQ (depth 31/32)


>>> Does seekmark use barriers

Barriers are not an issue with this test.

WARNING: never disable filesystem write barriers unless you have a
verified to be working battery/flash backed write cache hardware RAID
controller.  If you disable barriers with individual drives on SATA
controllers and the kernel crashes or you lose power, it can corrupt the
filesystem, sometimes beyond recovery.

-- 
Stan

