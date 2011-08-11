From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: single cpu thread performance limit?
Date: Thu, 11 Aug 2011 15:51:39 -0500
Message-ID: <4E4440DB.6020804@hardwarefreak.com>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>	<4E44265D.3050809@hardwarefreak.com> <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 8/11/2011 2:37 PM, mark delfman wrote:

> FS:  An FS is not really an option for this solution, so we have not
> tried this on this rig, but in the past the FS has degreaded the IOPS

I'm wondering what your applications is, given you have the option to
write to raw devices in production.

> Whilst a R0 on top of the R1/10's does offer some increase in
> performance, linear does not :(
> LVM R0 on top of the MD R1/10's does much the same results.
> The limiter seems fixes on the single thread per R1/10

This might provide you some really interesting results. :)  Take your 8
flash devices, which are of equal size I assume, and create an md
--linear array  on the raw device, no partitions (we'll worry about
redundancy later).  Format this md device with:

~$ mkfs.xfs -d ag=8 /dev/mdX

Mount it with:

~$ mount -o inode64,logbsize=256,noatime,nobarrier /dev/mdX /test

(Too bad you're running 2.6.32 instead of 2.6.35 or above, as enabling
the XFS delayed logging mount option would probably bump your small file
block IOPS to well over a million, if the hardware is actually up to it.)

Now, create 8 directories, say test[1-8].  XFS drives parallelism
through allocation groups.  Each directory will be created in a
different AG.  Thus, you'll end up with one directory per SSD, and any
files written to that directory will go that that same SSD.  Thus,
writing files to all 8 directories in parallel will get you near perfect
scaling across all disks, with files, not simply raw blocks.

I'm not really that familiar with FIO but I'll assume it can do file as
well as block IO.  If not, grab iozone or bonnie, etc, and run tests
writing small files to all 8 directories in parallel.  The results may
surprise you.  After you've done this, create 4 mirror pairs and then a
--linear of them.  Duplicate the above but use 4 allocation groups and 4
directories.  Please post the results for both test setups.

-- 
Stan
