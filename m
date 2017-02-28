From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: GRUB warning after replacing disk drive in RAID1
Date: Tue, 28 Feb 2017 23:34:13 +0100
Message-ID: <59c85e04-2f6a-1c81-ccba-fa8aac1c50ee@thelounge.net>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
 <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
 <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 28.02.2017 um 22:01 schrieb Peter Sangas:
> But I issue the grub command AFTER the re-sync is completed

output of "cat /proc/mdstat" and your environment missing!

* cat /proc/mdstat
* df -hT
* lsscsi
* lsblk

no pictures and interpretations, just copy&paste from the terminal 
(input as well as output)

please help others to help you

> -----Original Message-----
> From: Reindl Harald [mailto:h.reindl@thelounge.net]
> Sent: Tuesday, February 28, 2017 1:23 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: GRUB warning after replacing disk drive in RAID1
>
> Am 28.02.2017 um 00:37 schrieb Peter Sangas:
>> I have a RAID1 with 3 disks sda,sdb,sdc.  After replacing sdc and
>> re-syncing it to the array I issued the following command to load grub
>> but I get this
>> warning:
>>
>> grub-install /dev/sdc
>>
>> Installing for i386-pc platform.
>> grub-install: warning: Couldn't find physical volume `(null)'. Some
>> modules may be missing from core image..
>> grub-install: warning: Couldn't find physical volume `(null)'. Some
>> modules may be missing from core image..
>> Installation finished. No error reported.
>>
>> Does anyone know why I get this warning and how to avoid it
>
> it's harmless and disappears after the resync finished
