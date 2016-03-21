From: "Patrick Tschackert" <Killing-Time@gmx.de>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 23:06:17 +0100
Message-ID: <trinity-158217dd-e51b-4a8a-b40f-dd55ee5a1530-1458597977168@3capp-gmx-bs35>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas.Klauer@metamorpher.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for answering!

>> After rebooting the system, one of the harddisks was missing from my md raid 6 (the drive was /dev/sdf), so i rebuilt it with a hotspare that was already present in the system.
>> I physically removed the "missing" /dev/sdf drive after the restore and replaced it with a new drive.

>Exact commands involved for those steps?

Well since the /dev/sdf disk was missing from the array after the reboot, i didn't use any command to remove it. I just used
$ mdadm --run /dev/md0
to trigger the rebuild/restore. As i had two spare drives present in the array anyway, i thought that was the smartest thing to do.
After the restore was done, i shut down the system and swapped the missing disk (/dev/sdf) with a new one.
I then added the new disk to the array as a spare (mdadm --add /dev/md0 /dev/sdf)

> mdadm --examine output for your disks?
Here is the output for every disk in the array: http://pastebin.com/JW8rbJYY

> This is what you get when you use --create --assume-clean on disks
> that are not actually clean... or if you somehow convince md to
> integrate a disk that does not have valid data on, for example
> because you copied partition table and md metadata - but not
> everything else - using dd.

I didn't use that command or anything like that, i just triggered the rebuild with mdadm --run. It then started the restore (i monitored the progress by looking at /proc/mdstat), and it seemed to complete successfully.

> Your best bet is that the data is valid on n-2 disks.
> Use overlay https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
> Assemble the overlay RAID with any 2 disks missing (try all combinations) and see if you get valid data.

Thanks, I will definitely try that!
