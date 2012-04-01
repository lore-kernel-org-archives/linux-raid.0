From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sun, 01 Apr 2012 00:13:20 -0500
Message-ID: <4F77E3F0.2030802@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <CACwgYDNitxymtLT3SMw6m0_utqAzXPsOT5Y1CpwrjW1fN+xuqA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDNitxymtLT3SMw6m0_utqAzXPsOT5Y1CpwrjW1fN+xuqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: daobang wang <wangdb1981@gmail.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/31/2012 9:05 PM, daobang wang wrote:
> There is another problem occurred, it seems that the file system was
> damaged when the pressure is very high, 

What kernel version are you using?  Did you get an oops?  What's in dmesg?

> it reported input/output error

Actual errors would be very helpful.

> when i typed ls or other command, and I tried to repair it with
> xfs_repair /dev/vg00/lv0000, the xfs_repir alloc memory failed, we

Did XFS automatically unmount the filesystem?  If not, the error
reported may not indicate a problem with the filesystem.  XFS shuts
filesystems down when it encounters serious problems.

> have 4GB memory on the machine, and the logical volume was a little
> more than 15TB, Could it be repair successfully if we have enough
> memory?

Hard to say.  Depends on what happened and the extent of the damage, if
any.  You've presented no log or debug information.  I would think 4GB
should be plenty to run xfs_repair.  Try

$ xfs_repair -n -vv -m 1 /dev/vg00/lv0000

dmem = in the output tells you how much RAM is needed for xfs_repair.
If it's more than 2GB and you're using a PAE kernel, switch to a 64 bit
kernel and 64 bit userland.  If dmem is over 4GB then you need more
DIMMs in the machine.  Or maybe simply dropping caches before running
xfs_repair might help:

$ echo 3 > /proc/sys/vm/drop_caches

-- 
Stan
