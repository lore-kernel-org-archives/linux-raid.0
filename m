From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: How-to for enabling TRIM for SSD RAID-1 arrays?
Date: Fri, 13 Sep 2013 17:48:26 -0300
Message-ID: <CAH3kUhHRovY7fuQz4XK6_N+B5K0YHvZkPZoRp5GfVqtY8RpV3A@mail.gmail.com>
References: <CAD2NviVyoF4y9uQnvcng082zAGQoXq18JT7WM=+RfBGCzCp9zA@mail.gmail.com>
	<CAH3kUhHWm9Jz0X9sw1w4U_ni5dhoD0wXvtMcLn90UtjkqTW7Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHWm9Jz0X9sw1w4U_ni5dhoD0wXvtMcLn90UtjkqTW7Rw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Derek Piper <derek.piper@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

from what i found about md raid1 support in google:

http://lkml.indiana.edu/hypermail/linux/kernel/1203.1/01772.html
[patch 4/7] md: raid 1 supports TRIM
From: Shaohua Li
Date: Sun Mar 11 2012 - 23:14:04 EST

from ext4:
https://ext4.wiki.kernel.org/index.php/Ext4_Howto#Ext4_code_implements_discard.2FTRIM
https://sites.google.com/site/lightrush/random-1/howtoconfigureext4toenabletrimforssdsonubuntu
http://forums.gentoo.org/viewtopic-p-6187612.html


2013/9/13 Roberto Spadim <rspadim@gmail.com>:
> trim is enabled at mount option of filesystem (mount -t ext4 /dev/md0
> /home -o discard)
> for ext4 it's discard option if i'm not wrong
> last kernels have trim support in software raid-1 (md raid1 driver),
> just mount the filesystem over it and use, i don't know the exact
> kernel version but it's ~1 year old feature
>
> 2013/9/13 Derek Piper <derek.piper@gmail.com>:
>> Hi,
>>
>> Having found a posting on this list from July this year, I am trying to
>> find if (and how) TRIM support is supported and enabled under RAID 1 with 2
>> SSD drives.
>>
>> The posting was mentioned that it was included in the kernel source as of
>> October 11th 2012.
>>
>> I see nothing on the RAID wiki for enabling TRIM for SSD backed arrays. Any
>> pointers?
>>
>> I have a system with Debian 7 (Kernel 3.2, mdadm 3.2.5) that I am working
>> on.
>>
>> Thanks in advance,
>>
>> Derek
>>
>> --
>> Derek Piper - derek.piper@gmail.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Roberto Spadim



-- 
Roberto Spadim
