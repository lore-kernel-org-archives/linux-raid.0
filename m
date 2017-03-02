From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: GRUB warning after replacing disk drive in RAID1
Date: Thu, 2 Mar 2017 10:54:47 +0100
Message-ID: <0060f09f-b82f-f35b-55fb-8125c21c5403@thelounge.net>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
 <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
 <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
 <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
 <009601d29218$9fd3e460$df7bad20$@wnsdev.com>
 <97135270-088a-69da-8789-c64f1054ee72@thelounge.net>
 <008101d292e4$b1aeafe0$150c0fa0$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008101d292e4$b1aeafe0$150c0fa0$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 02.03.2017 um 00:36 schrieb Peter Sangas:
> Hi Reindl,
>
> My comments are interleaved. thanks:
> ___________________________________________________
>
>> #!/bin/bash
>
>> GOOD_DISK="/dev/sda"
>> BAD_DISK="/dev/sdc"
>
>> # clone MBR
>> dd if=$GOOD_DISK of=$BAD_DISK bs=512 count=1
>
> Here I run the command sfdisk -d /dev/$GOOD_DISK | sfdisk -f /dev/$BAD_DISK.
>
> I think dd and sfdisk are doing the same thing which is cloning the
> partitions and copy the MBR ?

yes

>> # force OS to read partition tables
>> partprobe $BAD_DISK
>
> Why run partprobe if the partitions have not changed?

because they *have* changed when you replace a disk with a complete 
empty one and clone the MBR and partition table with 3 partitions and 
have bootet with a empty partition table - not every hardware supports 
hotswap proper and even if it don't harm

>> # install bootloader on replacement disk grub2-install "$BAD_DISK"
>
> Here don't you mean grub-install not grub2-install?

no, i mean what i say since that script replaced multiple disks on 
multiple machines - but how does it matter which name a binary has on 
whatever distribution?

[harry@srv-rhsoft:~]$ rpm -q --filesbypkg grub2 | grep install
[harry@srv-rhsoft:~]$ rpm -q --filesbypkg grub2-tools | grep install
grub2-tools               /usr/sbin/grub2-install
grub2-tools               /usr/share/man/man8/grub2-install.8.gz
[harry@srv-rhsoft:~]$ cat /etc/redhat-release
Generic release 24 (Generic)


