From: Arun Khan <knura9@gmail.com>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Sat, 23 Feb 2013 20:29:50 +0530
Message-ID: <CAHhM8gC0zgmAY1hZ9uPCa3F7oYO2vh-84m4XoZmSa0NrtsDbsw@mail.gmail.com>
References: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
	<CAKHEz2bCyaqTa7dH-OFNR8_xs9O=XUD918vpVb+kL-gfOSq7gA@mail.gmail.com>
	<CAHhM8gA4JkC0ORbg2NhdxmQA3Ufag1fy48SPU-jE+MsjD9SRgQ@mail.gmail.com>
	<CAKHEz2ZDznrROkXRF6Mzmb4vVwkfG1ab+GPCwaAqML3i89fsuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2ZDznrROkXRF6Mzmb4vVwkfG1ab+GPCwaAqML3i89fsuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 13, 2013 at 2:58 AM, Dave Cundiff <syshackmin@gmail.com> wrote:
> On Tue, Feb 12, 2013 at 6:25 AM, Arun Khan <knura9@gmail.com> wrote:
>> I used 'watch cat /proc/mdstat' to watch the rebuild progress and the
>> progress bar showed completion (100%) mark.
>> When I broke out of this session and thereafter did 'cat /proc/mdstat'
>>  I noticed that not only was /dev/sdb1 not added but /dev/sdc1 was
>> also not part of the array anymore.   With two failed devices,
>> /dev/md0 was still working mounted on /mnt/md0.
>>
>
> have you tried adding the --force option to assemble? I would leave
> out sdb since its an empty drive.
>
> If that brings it online you can try a read-only fsck with -n to check
> the consistency of your data.

Yes did use --force to assemble but no joy.

Fortunately, I have been able to recover the data due to sheer luck!

I figured I was already in a hole so there was no harm in reconnecting
the 'failed' disk before RMA'ing it.
The disk (/dev/sdb)  was recognized by the BIOS,  the OS (Debian) did
not report and DRDY errors on the device.

The Events count for raid partition (/dev/sdb1) on this device
reported > zero.  So now I had three devices with Events > 0

So far so good ...

mdadm --assemble --force /dev/md0 /dev/sdb1 /dev/sdd1 /dev/sde1

did initialize /dev/md0 as active!

mdadm --add --force /dev/md0 /dev/sdc1
added  /dev/sdc1 into the array and I got a fully functional array.

Then I 'failed/removed' /dev/sdb1 from the array (the original failed
disk), /dev/md0 was still functional with 3 disks.

I connected the new hard disk, partitioned /dev/sdb1 to match size and
partition id (fd),

mdadm --add /dev/md0 /dev/sdb1  gave a fully functional /dev/md0

It was a shot in the dark and it worked!

Do not RMA a failing disk in a hurry, it might still save your day.

Thanks to all for your help.

-- Arun Khan
