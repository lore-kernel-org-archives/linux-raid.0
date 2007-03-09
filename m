From: "Simon Matthews" <simon.d.matthews@gmail.com>
Subject: Changing partition types safe? raidtools to mdadm migration
Date: Thu, 8 Mar 2007 22:39:01 -0800
Message-ID: <40b437200703082239s3d54df30n3b0f542f03770ad7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a working RAID1 set. This is in a Gentoo system and I
configured the RAID set using raidtools. I see that Raidtools are now
deprecated in favor of mdadm.

I installed mdadm, but it does not recognize my raid set. I tried the
following command (note that my RAID set is active while I do this):
$   mdadm /dev/md0 --query --detail

This results in no output.  I believe this is because I forgot to
change the partition types on the partitions that make up the RAID set
(/dev/sda1 and /dev/sdb1) to type fd (they are the default type 82).

Can I safely change the partition types to fd on the partions that
make up my RAID set?

Or is there something else I should do to get mdadm to recognize my RAID set?

Regards,
Simon
