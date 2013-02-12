From: Arun Khan <knura9@gmail.com>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Tue, 12 Feb 2013 16:55:31 +0530
Message-ID: <CAHhM8gA4JkC0ORbg2NhdxmQA3Ufag1fy48SPU-jE+MsjD9SRgQ@mail.gmail.com>
References: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
	<CAKHEz2bCyaqTa7dH-OFNR8_xs9O=XUD918vpVb+kL-gfOSq7gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2bCyaqTa7dH-OFNR8_xs9O=XUD918vpVb+kL-gfOSq7gA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 12, 2013 at 2:12 PM, Dave Cundiff  wrote:
>
> According to what I can see your array refuses to start because the
> mirrored pair sdb1 and sdc1 are both out of sync. Both are showing an
> event count of zero. That generally means the disk has never attempted
> to sync. The device role of "spare" on both of these disks reinforces
> that fact.

Monday, evening when I swapped in a good HDD (with the /dev/sdb1
member), the other three devices were working fine.

In fact, the device /dev/md0 was mounted on /mnt/md0, using System
Rescue CD Live session.

> Are you sure sdc1 was active, sync'd, and in the array before sdb1 failed?
> Could you have accidentally cleared the superblock on sdc1 as well?

I used 'watch cat /proc/mdstat' to watch the rebuild progress and the
progress bar showed completion (100%) mark.
When I broke out of this session and thereafter did 'cat /proc/mdstat'
 I noticed that not only was /dev/sdb1 not added but /dev/sdc1 was
also not part of the array anymore.   With two failed devices,
/dev/md0 was still working mounted on /mnt/md0.

I did not clear the superblock on /dev/sdc1.

Tue AM, after reboot, /dev/md0 remains in inactive state.

Please let me know if you can think of anything that will get me out
of this mess.

I will try to use a  distro with a new version of mdadm + kernel.

Thanks.
-- Arun Khan
