From: rrk <rrk@prairie.lakes.com>
Subject: bd_claim error
Date: Sun, 20 Mar 2005 02:05:35 -0600
Message-ID: <423D2ECF.6040103@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i was building a simple raid 1 array and when i went to add hda1 i got a
mdadm could not bd_claim hda1  error the mdstat shows md0 up and running
this is the first time i have seen this error kernel is 2.6.10 
debian/kanotix with raid built in
what does it mean?

this is what i did
mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/hdc1
set partition type to fd for both drives
mkfs.ext3 /dev/md0
cp -R /  /mnt/hdc1

edited grub to boot from hdc1
rebooted
chked mdstat
and checked superblocks with mdadm -E /dev/md0 /dev/hdc
all looked good
mdadm --add /dev/md0 /dev/hda1 
failed with mdadm could not bd_claim hda1
md error  md_import_device() returned -16

thanks
rob
