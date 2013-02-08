From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Raid1 to Raid 10
Date: Sat, 09 Feb 2013 01:58:00 +1100
Message-ID: <51151278.20806@websitemanagers.com.au>
References: <S1758867Ab3BGRFg/20130207170536Z+12@vger.kernel.org> <5115090A.5040908@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5115090A.5040908@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Cocolocko <cocolocko@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/13 01:17, Cocolocko wrote:
> is it possible to expand/upgrade a existing Software Raid1 with two
> harddisks under CentOS 6.3 to a Raid 10?
> I want to put 2 more disks inside to have more speed for Databases and
> KVM virtualisation with the Raid0.
Personally, I'd do something like this:
1) Physically add the 2 new drives
2) Create a RAID10 array with two missing drives, something like:
mdadm --create /dev/md10 --level=raid10 --raid-devices=4 /dev/sdc1
missing /dev/sdd1 missing
3) Unmount, stop using the existing RAID1
4) Copy old RAID1 (md1) to new RAID10 (md10)
dd if=/dev/md1 of=/dev/md10
5) Destroy old RAID1
mdadm -S /dev/md1
mdadm --zero-superblock /dev/sda1
mdadm --zero-superblock /dev/sdb1
6) Add the old RAID1 devices to the RAID10
mdadm --manage /dev/md10 --add /dev/sda1
mdadm --manage /dev/md10 --add /dev/sdb1

You should check that all the above command lines are valid/correct, and
especially the device names.

You might also like to carefully specify the chunk size, as this can
impact performance.

Finally, you might consider with 4 disks will be enough, you can't grow
a RAID10 array (except replace all disks with larger ones) to improve
performance, so perhaps you should use 8 smaller disks instead of 4
large disks and try and get faster disks (rpm) to maximise performance.

Hope this helps.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

