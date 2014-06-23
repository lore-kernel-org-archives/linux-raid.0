From: Theodotos Andreou <theo@ubuntucy.org>
Subject: Restoring a RAID 10 disk array
Date: Mon, 23 Jun 2014 17:04:15 +0300
Message-ID: <53A833DF.8050004@ubuntucy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all,

I have a RAID 1 RAID 10 setup that failed. I booted with a recovery usb 
(grml) to try to recover the system. Let me explain the setup to you.

This is my parted listing:

http://pastebin.com/6QdyXRQN

The first partitions (/dev/sd[ad]1) are for EFI. No  RAID here

The second partitions (/dev/sd[ad]2) are the /boot filesystem. This used 
to be /dev/md0 and it is a RAID 1 setup.

The third partitions (/dev/sd[ad]3) is the LVM physical volume which 
hosts all the rest. It used to be /dev/md1 and it is a RAID 10 setup.

For the parted listing it looks like there is some partition table 
corruption on /dev/sdd.

When I try 'mdadm --verbose --assembly --scan' I get:

http://pastebin.com/iqGF9En7

The output of 'mdadm -Evvvvs' is:

http://pastebin.com/kizjT7xE

Assuming I replace the sdd disk and create the appropriate partition 
scheme, what is the correct methodology to restore my md devices? I 
don't care much about /dev/md0 but mostly for the /dev/md1 partition 
where there are all the data.

Regards

Theo
