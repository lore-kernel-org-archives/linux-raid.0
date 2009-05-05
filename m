From: Michal Soltys <soltys@ziu.info>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 05 May 2009 11:31:27 +0200
Message-ID: <4A00076F.9010402@ziu.info>
References: <1240574900.4507.2076.camel@ezra>	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>	<1240957153.18303.689.camel@ezra>	<e9c3a7c20904281526i59983678mb6fbc10e1761d9f1@mail.gmail.com>	<87ljpgleku.fsf@frosties.localdomain>	<e9c3a7c20905011424s6c3b3fd6ya563539b3c079d4@mail.gmail.com> <87r5z8jvxe.fsf@frosties.localdomain> <49FC376C.6050508@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49FC376C.6050508@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> John Robinson wrote:
>> Which still has the same problems as the raid5. How to handle the
>> bootloader. Say I have a raid1 over sda/b with lvm on it. How do I
>> boot that? How do I get the bootloader cloned to a new spare disk when
>> it gets added?
> 

Btw - if you have _only_ raid1 on the drives, then you can also set up
partitionable md raid1 with its superblock at the end of the device. 
Thus -  linux raid will cover _whole_ disk, while remaining capable of 
booting with /boot partition in a typical way if /boot was raid1 over 
sd[abc..]1

As for booting itself - the key thing is to have "tiny" /boot partition
_with_ simple well understood and supported filesystem (such as fat,
ext2) at the beginning - outside of lvm or more complex raids. Such a
partition can have - apart from linux kernel+initramfs - bootable
freedos or linux, and host some good bootloader/manager (such
as syslinux, which is far more powerful and flexible than grub).

If /boot is created inside some container (lvm, raid5) and/or as a part 
of other filesystem - then it only ties hands, imho.

>> On Fri, May 1, 2009 at 2:04 PM, Goswin von Brederlow 
>> <goswin-v-b@web.de> wrote:
> `dd if=/dev/originaldrive of=/dev/newdrive bs=512 count=1` to clone the 
> boot sector from one of the remaining original drives; this clones your 
> partition table too. Once that's done, and you've added the new drive's 
> partition(s) back into the RAID set(s) and it's synced, it will boot.
> 

Assuming you have no extended/logical partitions. In case of
legacy partitions, it's better to use:

sfdisk -d /dev/sda >pt.dump

and later to restore somewhere else

sfdisk /dev/sdb <pt.dump

Also - the 'dd' method would also clone disk signature (4 bytes at
1B8h), which depending on the needs, may not be desirable.

