From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: dmesg deluge: RAID1 conf printout
Date: Sun, 22 Apr 2012 10:17:49 +0200
Message-ID: <4F93BEAD.3090405@computer.org>
References: <4F92BC43.3010603@computer.org> <20120422070041.7e4b95e7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120422070041.7e4b95e7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
>> Anything I can do about that?
>
> Best thing you can do it report it and hope some maintainer notices and helps
> out.   Oh wait, you did that :-)
>
> Looks like:
>
>     commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3
>
> is at fault.  It causes md to attempt to add spares into the array more often.
> Would I be right in guessing that you have one spare in this array?
> If you remove the spare, the messages should stop.

Hi Neil.

As ever many thanks for your responsiveness and helpfulness.

I have two RAID1 sets, each with one spare:

root@zotac:~# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid1 sdb1[1] sde2[2](S) sdd1[0]
       521984 blocks [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

md1 : active raid1 sdb2[1] sde3[2](S) sdd2[0]
       487861824 blocks [2/2] [UU]
       bitmap: 1/4 pages [4KB], 65536KB chunk

unused devices: <none>

As you can see, there are no spares to add. Upon my last reboot the 
spares were added automatically. Having said that, upon the previous 
reboot I had to add them manually. The devices in question were also 
missing from /dev/disk/by-uuid. This may be an entirely different 
problem though, and not one I'm worried about given the mismatch between 
the kernel version and the rest of the distro.

I'm only running this recent a kernel because its support of a 
particular piece of hardware I have seems to be much more stable than 
with my distro's regular kernel.

In case it's important:

root@zotac:~# cat /etc/mdadm/mdadm.conf | grep -v ^#

DEVICE partitions

CREATE owner=root group=disk mode=0660 auto=yes

HOMEHOST <system>

MAILADDR root

ARRAY /dev/md0 level=raid1 num-devices=2 spares=1 
UUID=c2bfb80c:0cbf5cd9:67c62432:ead2ec0c
ARRAY /dev/md1 level=raid1 num-devices=2 spares=1 
UUID=442e9934:97191d8e:6d0cf7a9:41621837

> I think I know how I'll fix it but it'll have to wait for tomorrow.  Then
> I'll send you a patch to test.

I'll have to set up a build environment, but I'll certainly give that a go.

Thanks, Jan
