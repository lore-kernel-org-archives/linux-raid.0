From: Robert L Mathews <lists@tigertech.com>
Subject: Re: root in grub for raid1
Date: Sat, 17 Dec 2016 11:46:50 -0800
Message-ID: <9a6fa611-79ea-e6ef-c0dc-c75529a37218@tigertech.com>
References: <20161216221414.7c67f80b@para.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161216221414.7c67f80b@para.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/16/16 1:14 PM, Egbert Bouwman wrote:
> Newbie, but this list seems to be for developers.
> If that is true I'll ask my one question, and then retire.

It's for both, so this is fine.


> Actually it is a question about grub, but I think the raid specialists
> know more about this grub problem than the grubbers do.
> 
> Setting up raid1 for /dev/sda and /dev/sdb (actually for missing and /dev/sdb)
> on /dev/md/data succeeded, but now I have to do a dpkg-reconfigure
> grub-efi-amd64 and i don't know how to specify root in the two grub lines: 
> 	set root=...
> and the linux command line
> 	linux root=
> Please note that i chose md/data, and not the common md0.

Here's how Debian's installer automatically set it up on one of our
machines, which should help.

df:
/dev/md0      497817      30722    456815   7% /boot


mdadm --detail /dev/md0:
 0       8        1        0      active sync   /dev/sda1
 1       8       17        1      active sync   /dev/sdb1
 2       8       33        2      active sync   /dev/sdc1


blkid:
/dev/sda1: UUID="97dad9d1-ffbd-302a-f0d9-91deb32240d0"
UUID_SUB="cf4cfce6-2f61-d15c-2ebf-3aea07f9644c" TYPE="linux_raid_member"

/dev/sdb1: UUID="97dad9d1-ffbd-302a-f0d9-91deb32240d0"
UUID_SUB="c879211d-9efa-3f08-6d54-0f2f3249a839" TYPE="linux_raid_member"

/dev/sdc1: UUID="97dad9d1-ffbd-302a-f0d9-91deb32240d0"
UUID_SUB="51e0ab31-8fb4-8be3-7626-3ab449732c24" TYPE="linux_raid_member"

/dev/md0: UUID="4e19f8d1-d373-42f1-832b-4da7c1a72930" TYPE="ext3"


And finally, here's the grub.cfg lines:

 set root='(mduuid/97dad9d1ffbd302af0d991deb32240d0)'
 search --no-floppy --fs-uuid --set=root
4e19f8d1-d373-42f1-832b-4da7c1a72930
 echo    'Loading Linux 3.2.0-4-amd64 ...'
 linux   /vmlinuz-3.2.0-4-amd64
root=UUID=04324b83-7740-49cd-8866-cb88e1a54845 ro  quiet radeon.modeset=0

So it appears the first "set root=" line should be the blkid UUID of the
underlying partitions (/dev/sdb in your case?), and the second "search
--set=root" should be the UUID of the RAID partition (/dev/md/data is
your case?).

Works on our machines, anyway. <shrug>

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
