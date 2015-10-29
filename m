From: Phil Turmel <philip@turmel.org>
Subject: Re: 2nd Faulty drive while rebuilding array on RAID5
Date: Thu, 29 Oct 2015 08:21:58 -0400
Message-ID: <56320F66.6030109@turmel.org>
References: <CABEdK7w7zjjEXXenWRK0BSziekBGhkni50y0j3t=rW2AxNkkqQ@mail.gmail.com>
 <562D67E3.6050708@turmel.org>
 <CABEdK7wDU42phn2RTqUQWVTCet5v+WqtRYoD0ezvHXpGioapmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABEdK7wDU42phn2RTqUQWVTCet5v+WqtRYoD0ezvHXpGioapmQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume ALLEE <guillaume.allee@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Guillaume,

On 10/28/2015 04:35 PM, Guillaume ALLEE wrote:

> Thanks for your answer. I have tested my sda3 with badblocks and it
> seems really bad like 6 digits unreadable blocks...

Hmm.  Is there any chance your cabling or power supply is at fault?

>> Something's missing.  I see only sd[abcd]3.  Where's the report for
>> /dev/sde* ?
> Yep because /dev/sde is not part of my /dec/md1 array.

Ok.

> "ARRAY /dev/md1 level=raid5 num-devices=4 metadata=00.90
> UUID=426d71a2:5b25a168:a4e2eff2:d305f1c1
>    devices=/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sdd3"

Just for future reference:  you aren't expected to keep the output of
"mdadm -Es" as your permanent mdadm.conf.  Your system will be much more
robust if you trim that to just the MD device name and the UUID.

>> Yes, you have WD20EARS and ST3000DM001 drive models.  These are not safe
>> to use in raid arrays due to lack of error recovery control.
> Okay I will look at that for my next HDs.

Yes, it should guide your future purchasing, but you have a crisis on
your hands -- you *must* set your driver timeouts to deal with your
consumer-grade desktop drives or your array *will* crash again *soon*.

>> You need to stop the array and perform an '--assemble --force' with the
>> last four devices (exclude /dev/sdc).  The ones that have "Raid Device"
>> 0, 1, 2, & 3.
> Here is the assemble output.
> 
> #mdadm --assemble --force /dev/md1 /dev/sda3 /dev/sdb3 /dev/sdd3
> mdadm: no recogniseable superblock on /dev/sda3
> mdadm: /dev/sda3 has no superblock - assembly aborted

Hmmm.  You need three readable drives with original data to get out of
this trap.  What happened to the original /dev/sdc?  Using it with a
carefully constructed --create --assume-clean may be your only chance to
recover anything.

Also, before you risk wiping anything else, generate mdadm -E reports
for each device along with a "smartctl -i -A -l scterc" report.  That
ties the array details (especially role) for each device to the drive
serial number.  As you plug and unplug devices, names can change.

Just post that information inline in your next reply -- no need to use
pastebin.

Phil

