From: Emery Guevremont <emery.guevremont@gmail.com>
Subject: [SOLVED] Re: On RAID5 read error during syncing - array .A.A
Date: Mon, 29 Dec 2014 14:40:39 -0500
Message-ID: <CAB_L8satSMfZC1dd5Ex=HUX1QXeX4yYez4wcU2TPYJDQxBYqqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Emery Guevremont <emery.guevremont@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I just wanted to document in this thread the commands and steps I
followed with Robin's help after having a second drive fail during the
synching of a RAID5 array.

- First step I did was take a picture of my error on screen. And save
a copy of the output of
mdadm -E /dev/sd[abcd]3
and
mdadm --detail --scan /dev/md0.
and
smartctl -a /dev/sda #for each drives since it was nice to have the
serial numbers match up with each UUID device mdadm -E gave.

- Second step I did was to boot with a liveusb and use ddrescue to
clone 3 of my 4 drives. The first drive that failed was totally
malfunctioning, but I was able to ddrescue my 3 other drives. I booted
with ubuntu's rescue remix live usb distro and ddrescued each drive
one at a time with a new drives I purchased.

ddrescue -f -n /dev/sda /dev/sdb /mnt/sdc2/ddrescue.sda.log
ddrescue -f -r3 /dev/sda /dev/sdb /mnt/sdc2/ddrescue.sda.log

- After the cloning process was done, I booted again with only the new
cloned drives. I ran
mdadm -E /dev/sd[abc]3 | grep "UUID Dev"
and compared that output to the one I took original when everything
first failed. This was important since the ordering of my drives did
not match anymore. After figuring out the correct order I ran thing
command that Robin helped me sort out.

mdadm -v --create --assume-clean --level=5 --chunk=512
--size=1952795136 --raid-devices=4 /dev/md0 /dev/sdd3 /dev/sdb3
/dev/sdc3 missing

- At this point I was able to run
fsck -n /dev/md0
which told me my ext4 partition was clean.

From this point on you have 2 options. mount in read-only and backup,
or insert a new drive to add to your array. I went the safe way and
mounted in read-only:

mount -o ro,noload /dev/md0 /mnt
rsync -axvSH /mnt/ /mnt2/

- The final step for me was to add a new fourth drive to my degraded
raid5 array.
mdadm --add /dev/md0 /dev/sda3
A cat /proc/mdstat confirmed the resynching process.
