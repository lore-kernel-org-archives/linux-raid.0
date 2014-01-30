From: Chris Schanzle <mdadm@cas.homelinux.org>
Subject: Re: non-persistent superblocks?  [WORKAROUND]
Date: Thu, 30 Jan 2014 11:46:31 -0500
Message-ID: <52EA81E7.7010906@cas.homelinux.org>
References: <52E9D9CC.9000908@cas.homelinux.org>
 <BLU0-SMTP148F6E0422558E051D1067198AF0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <BLU0-SMTP148F6E0422558E051D1067198AF0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/30/2014 05:16 AM, Wilson Jonathan wrote:
> On Wed, 2014-01-29 at 23:49 -0500, Chris Schanzle wrote:
>
> <snip, as my reply might be relevent, or not>
>
> Two things come to mind, the first is if you updated the mdadm.conf
> (/etc/mdadm/mdadm.conf or /etc/mdadm.conf)
>
> The second is, update-initramfs -u to make sure things are setup for the
> boot process. (I tend to do this when ever i change something that
> "might" change a boot process... even if it does not, its pure habit as
> apposed to correct procedure)

Thanks for these suggestions. Fedora's /etc/mdadm.confshouldn't be necessary to start the array (yes for mdadm monitoring): this is not a boot device and the kernel was finding the lone single late-added parity disk on boot.

As for updating the initramfs, it didn't make sense to try this as the late-added parity disk was being discovered so the kernel modules were available.  It seems update-initramfs is for Ubuntu, for Fedora it's dracut.  BTW, rebooting with (the non-hostonly) rescue kernel made no difference; it could have since the original install was on a non-raid device so it has no reason to include raid kernel modules.


I got inspiration from https://raid.wiki.kernel.org/index.php/RAID_superblock_formats to switch superblock format from 1.2 (4k into the device) to the beginning of the device.  Success!

Precisely what I did after a reboot, starting/recreating md0 as mentioned previously:

mdadm --detail /dev/md0
vgchange -an
mdadm --stop /dev/md0
# supply info from above 'mdadm --detail' to parameters below
mdadm --create /dev/md0 --assume-clean --level=5 --raid-devices=5 --chunk=512 --layout=left-symmetric --metadata=1.1  /dev/sd{a,b,c,d,e}

At this point I had an array with a new UUID, could mount stuff, see data, all was good.

mdadm --detail --scan >> /etc/mdadm.conf
emacs !$ # commented out the previous entry
cat /etc/mdadm.conf
#ARRAY /dev/md0 metadata=1.2 name=d130.localdomain:0 UUID=011323af:44ef25e9:54dccc7c:b9c66978
ARRAY /dev/md0 metadata=1.1 name=d130.localdomain:0 UUID=6fe3cb23:732852d5:358f8b9e:b3820c6b

Rebooted and my array was started!

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdc[2] sdb[1] sda[0] sdd[3] sde[4]
       15627548672 blocks super 1.1 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
       bitmap: 0/30 pages [0KB], 65536KB chunk

I believe there is something broken with having a gpt-labeled disk (without partitions defined) that is incompatible with superblock version 1.2.

