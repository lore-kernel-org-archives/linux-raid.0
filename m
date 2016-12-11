From: juca@juan-carlos.info
Subject: What is the solution for USB HDs
Date: Sun, 11 Dec 2016 19:14:11 +0200
Message-ID: <13e51316a11df7b0c9f5ab89392361de@juan-carlos.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Linux-RAID Developers,

I always wanted to have a small home server with a RAID-array to store 
pesonal and work files.

So I decided to create a fileserver with a raspberry pi and a RAID-1 
Array. For this I bought two USB 1TB HDs.

After a while I noticed that Mdadm was marking my drives as failed or 
even worse as faulty. This was strange since both HDs are new.

So I tested them. I deleted the RAID partitions completely with WIPEFS. 
Then I created Ext4 partitions and run a benchmark of the partitions in 
ubuntu. Everything is fine.

I created then again my RAID array. To my surprise one drive was again 
faulty. I googled a little  and I found that my USB drives went to sleep 
mode and when they were woken up, one of them changed name /dev/sdb/ -> 
/dev/sdc. Mdadm was unable to find the "new" drive and marked it as 
faulty. Re-add didn't work. Adding it again went into an unnecessary and 
long sync of 1TB.

I googled the problem and learnt about UDEV. It turns out that Linux 
gracefully creates symlinks to the disks-partitions under 
/dev/disks/by-id/... I thought that I could use this symlinks to fix the 
problem with Mdadm, but mdadm just followed the links to find again the 
changing /dev/sd* names.

I continued my journey and found more about the UDEV rules. I created a 
couple of them, using the serial number of the disks. I turns out that 
changing the name is not anymore allowed. (NAME="sdb" is ignored) There 
is even a warning about this. See here: 
http://unix.stackexchange.com/questions/119593/is-there-a-way-to-change-device-names-in-dev-directory
"NAME="pendrak" ignored, kernel device nodes can not be renamed; please 
fix it in /etc/udev/rules.d/99-local.rules:1"

My last desperate idea was to create a cron job that reads directly from 
the disks, to keep them awake and avoid a name change. Something like 
this:

dd if=/dev/disk/by-id/usb-TOSHIBA_External_USB_3.0_20151214504D3-0:0 
bs=1024 count=$(($[1<<10]*10)) skip=$(($SKIP)) ibs=1024 of=/dev/null 
iflag=direct status=none 2>&1

But even with that workaround the name of a disk just changed and Mdadm 
marked it as faulty. --- I'm out of ideas.

So I'm stuck with this wonderful situation:

- MDADM will follow symlinks and ignore the /dev/disk/by-id/... 
identification.
- UDEV does not allow to change the name of a device.
- The names will apparently change no matter what I do.

I'm starting to regret my decision to create this array. I expected some 
challenges but it is turning to be ridiculously difficult. Almost 
unusable.

Maybe you have a solution for this.

In any case it would be great if you consider some long-term 
out-of-the-box solution for this new reality of USB HDs. My ideas would 
be:

-- Allow to create arrays with symlinks 
("/dev/disk/by-id/usb-TOSHIBA_External_USB_3.0_20151214504D3-0:0")

-- Include a keep-alive functionality that avoids names to change 
randomly.

-- Store HD ids to recognize disks.

Thank you.

Best regards,

Juan Carlos Carvajal Bermúdez
+43 650 477 0005
juca@juan-carlos.info
Beingasse 17/2/3
AT 1150, Wien
www.juan-carlos.info
