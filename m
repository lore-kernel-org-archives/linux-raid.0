From: Luca Berra <bluca@comedia.it>
Subject: Re: imsm woes (and a small bug in mdadm)
Date: Wed, 23 Dec 2009 14:48:23 +0100
Message-ID: <20091223134823.GA18870@maude.comedia.it>
References: <20091222175128.GA18191@maude.comedia.it> <e9c3a7c20912221557p18bb5675ofb148af3164d7c9c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20912221557p18bb5675ofb148af3164d7c9c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

first thing, thanks for your attention.

On Tue, Dec 22, 2009 at 04:57:49PM -0700, Dan Williams wrote:
>On Tue, Dec 22, 2009 at 10:51 AM, Luca Berra <bluca@comedia.it> wrote:
>> try rebuilding it under linux, the linux box used dmraid instead of
>> mdadm and was obviously unable to boot (did i ever mention redhat/fedora
>> mkinitrd sucks).
>
>Things get better with dracut.
i had a cursory look at it, and it seems to be very nice....

>> it is now rebuilding
>>
>> i still have to see what bios thinks of the raid when i reboot
>>
>
>Everything looks back in order now, let me know if the bios/Windows
>has any problems with it.

after rebuild and reboot Volume0 was ok,
Volume 1 was in state "Initializing" and windows rebuilt it again,
this leads me to believe even mdadm-3.1.1 is not perfect yet.

>> attached, besides the patch are
>> mdadm -Dsvv and mdadm -Esvv before and after the hot-remove-add, in case
>> someone has an idea about what might had happened.
>>
>
>Thanks for the report.  I hit that segfault recently as well, and your
>fix is correct.
>
>Is sdb the drive you replaced, or the original drive?  The 'before'
sdb was the 'original' drive.
>record on sdb shows that it is a single disk array with only sda's
>serial number in the disk list(?), it also shows that sda has a higher
>generation number.  It looks like things are back on track with the
>latest code because we selected sda (highest generation number),
>omitted sdb because it was not part of sda's disk list, and modified
>the family number to mark the rebuild as the bios expects.
so 3.0.2 does something which is not correct???
which is the suggested mdadm version for imsm then, 3.1.1 or your git?
my data wasn't important, but i'd like to avoid someone else loosing
data.

>The bios marked both disks as offline because they both wanted to be
>the same family number, but they had no information about each other
>in their records, so it needed user intervention to clear the
this is strange, since one of the test i did was powering on the pc with
only one disk connected (tried with both of them)
>conflict.  It would have been nice to see the state of the metadata
>after the crash, but before the old mdadm [1] touched it as I believe
>that is where the confusion started.
unfortunately i did not forsee any problem so i did not take a snapshot.
btw besides mdadm -D (-E) is there any other way to collect binary
metadata (dd if=/dev/sd? bs=? skip=? count=?) ?


Regards,
L.
-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
