From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Documentation? failure to update-initramfs causes Infinite md loop
 on boot
Date: Wed, 30 Jan 2008 16:32:46 -0600
Message-ID: <47A0FB0E.5020202@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I reformatted the disks in preparation to my move to a RAID1/RAID5 
combination. I couldn't --stop the array (that should have told me 
something), so I removed ARRAY from mdadm.conf and restarted. I ran 
fdisk to create the proper partitions, and then I removed the /dev/md* 
and /dev/md/* entries in anticipation of creating the new ones. I then 
rebooted to pick up the new partitions I'd created.

Now I can no longer boot, with this series of messages:

md: md_import_device returned: -22
md: mdadm failed to add /dev/sdb2 to /dev/md/all: invalid argument
mdadm: failed to RUN_ARRAY /dev/md/all: invalid argument
md: sdc2 has invalid sb, not importing!

Thousands of these go past, and there's no escape. That's quite a severe 
error. I'm going to boot on a rescue disk to fix this -- there's no 
other way I can think of to get out of this mess -- but I wonder if 
there ought to be documentation on the interaction between mdadm and 
update-initramfs.

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
"Becoming the biggest banana republic in the world -- and without the 
bananas, at that -- is an unenviable prospect."
    			-- Sergei Stepashin, Prime Minister of Russia
