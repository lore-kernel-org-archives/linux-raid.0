From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID1 root and swap and initrd
Date: Thu, 21 Dec 2006 17:45:27 +0300
Message-ID: <458A9E07.2040608@tls.msk.ru>
References: <20061215175630.GA11400@aym.net2.nerim.net> <Pine.LNX.4.64.0612151909210.27298@lion.drogon.net> <20061216210517.GB11400@aym.net2.nerim.net> <45846A43.8070207@tls.msk.ru> <45885A06.6070100@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45885A06.6070100@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andre Majorel <aym-xunil@teaser.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[A late follow-up]

Bill Davidsen wrote:
> Michael Tokarev wrote:
>> Andre Majorel wrote:
>> []
>>  
>>> Thanks Jurriaan and Gordon. I think I may still be f*cked,
>>> however. The Lilo doc says you can't use raid-extra-boot=mbr-only
>>> if boot= does not point to a raid device. Which it doesn't because
>>> in my setup, boot=/dev/sda.
>>>
>>> Using boot=/dev/md5 would solve the raid-extra-boot issue but the
>>> components of /dev/md5 are not primary partitions (/dev/sda5,
>>> /dev/sdb5) so I don't think that would work.
>>
>> So just move it to sda1 (or sda2, sda3) from sda5, ensure you've
>> two identical drives (or at least your boot partitions are layed
>> up identically), and use boot=/dev/md1 (or md2, md3).  Do NOT
>> use raid-extra-boot (set it to "none"), but set up standard mbr
>> code into boot sector of both drives (in debian, it's 'mbr' package;
>> lilo can be used for that too - once for each drive), and mark your
>> boot partition on both drives as active.
>>
>> This is the most clean setup to boot off raid.  You'll have two
>> drives, both will be bootable, and both will be updated when
>> you'll run lilo.
>>
>> Another bonus - if you'll ever install a foreign OS on this system,
>> which tends to update boot code, all your stuff will still be intact -
>> the only thing you'll need to do to restore linux boot is to reset
>> 'active' flags for your partitions (and no, winnt disk manager does
>> not allow you to do so - no ability to set non-dos (non-windows)
>> partition active).
>>
>>> I *could* run lilo once for each disk after tweaking boot= in
>>> lilo.conf, or just supply a different -M option but I'm not sure.
>>> The Lilo doc is not terribly enlightening. Not for me, anyway. :-)
>>
>> No, don't do that. Even if you can automate it.  It's error-prone
>> to say the best, and it will bite you at an unexpected moment.
> 
> The desirable solution is to use the DOS MBR (boot active partition) and
> put the boot stuff in the RAID device. However, you can just write the
> MBR to the hda and then to hdb. Note that you don't play with the
> partition names, the 2nd MBR will only be used if the 1st drive fails,
> and therefore at the BIOS level the 2nd drive will now be hda (or C:) if
> LILO stiff uses the BIOS to load the next sector.

Just a small note.  DOS MBR can't boot from non-primary partition.
In this case, the boot code is at sda5, which is on extended partition.

But.  Lilo now has ability to write its own MBR, which, in turn, IS
able to boot of logical partition.

 lilo -M /dev/sda ext

/mjt
