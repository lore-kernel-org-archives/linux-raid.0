From: James Brown <jbrown@orange.net>
Subject: Re: Newbie: Kernel panic during RAID1 test & reboot loses one disk
Date: Mon, 28 Aug 2006 23:53:27 +0200
Message-ID: <44F365D7.2020001@orange.net>
References: <ecqek4$tnu$1@sea.gmane.org> <17650.19291.747235.505927@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17650.19291.747235.505927@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday August 26, jbrown@orange.net wrote:
>> All,
>>
>> [...]
>>
>> * Problem 1: Since moving from 2.4 -> 2.6 kernel, a reboot kicks one 
>> device out of the array (c.f. post by Andreas Pelzner on 24th Aug 2006).
>>
>> * Problem 2: When booting my system, unless both disks plugged in, I get 
>> a kernel panic (oh dear!):
>>
>>  > mdadm md0 stopped
>>  > mdadm cannot open device /dev/hda6 no such device or address
>>  > mdadm /dev/hda6 has wrong uuid
>>  > mdadm no devices found for /dev/md0
>>  > ext3fs unable to read superblock
>>  > ecit 2 - unable to read superblock cramfs
>>  > kernel panic attempting to kill init
> 
> At a guess, I'd say something is wrong with your initramfs/initrd.
> Can you look inside it and see what /etc/mdadm/mdadm.conf contains?

Sure, this is the first time I've mounted an initrd, here goes:

# file /boot/initrd.img-2.6.8-3-386
[...]Linux Compressed ROM File System data, little endian size 4333568 
version #2 sorted_dirs CRC 0xa04ccaa3, edition 0, 2492 blocks, 312 files

# losetup /dev/loop0

# mkdir /tmp/initrdmount

# mount -t cramfs /dev/loop0 /tmp/initrdmount

# ls -al /tmp/initrdmount/etc/
total 1.0K
drwxr-xr-x  1 root root 64 1970-01-01 01:00 modprobe.d/
-rw-r--r--  1 root root  0 1970-01-01 01:00 mtab

There is no mdadm/mdadm.conf! What I should do about this?

> [...]
>> * System md logs don't mention hdc6
>> # grep md /var/log/messages
> 
>  grep -C 5 md /var/log/messages
> might be better as it gives a bit more context.l

I've put the messages here:

http://www.zen6780.zen.co.uk/messages.txt

Many thanks for your time.

James.

> But I'm betting on the initramfs being a problem.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

