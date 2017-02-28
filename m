From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: GRUB warning after replacing disk drive in RAID1
Date: Tue, 28 Feb 2017 13:01:53 -0800
Message-ID: <008001d29205$e4f503c0$aedf0b40$@wnsdev.com>
References: <002f01d29152$737b4550$5a71cff0$@wnsdev.com> <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ab6d048b-b944-6661-11a5-503012dfad50@thelounge.net>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Reindl Harald' <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

But I issue the grub command AFTER the re-sync is completed.

-----Original Message-----
From: Reindl Harald [mailto:h.reindl@thelounge.net] 
Sent: Tuesday, February 28, 2017 1:23 AM
To: linux-raid@vger.kernel.org
Subject: Re: GRUB warning after replacing disk drive in RAID1



Am 28.02.2017 um 00:37 schrieb Peter Sangas:
> I have a RAID1 with 3 disks sda,sdb,sdc.  After replacing sdc and 
> re-syncing it to the array I issued the following command to load grub 
> but I get this
> warning:
>
> grub-install /dev/sdc
>
> Installing for i386-pc platform.
> grub-install: warning: Couldn't find physical volume `(null)'. Some 
> modules may be missing from core image..
> grub-install: warning: Couldn't find physical volume `(null)'. Some 
> modules may be missing from core image..
> Installation finished. No error reported.
>
> Does anyone know why I get this warning and how to avoid it

it's harmless and disappears after the resync finished
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

