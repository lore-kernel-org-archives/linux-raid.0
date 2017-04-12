From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Linux software raid troubles
Date: Wed, 12 Apr 2017 17:29:17 +0200
Message-ID: <cbadbdeb-7e6b-7784-e49c-dd2801903bb6@thelounge.net>
References: <CAAO=44Y=8xrnWvMp214RFq9Y-KVDQVfEYa2vL-Ahgmbvgs6Y4w@mail.gmail.com>
 <8e9a25fc-5c81-103c-2ffa-4b46f2aa8630@thelounge.net>
 <CAAO=44bsG1yrmYbag1eruNA_tdXxqiJptnRyPB=4TW6r5771HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAO=44bsG1yrmYbag1eruNA_tdXxqiJptnRyPB=4TW6r5771HQ@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: linuxknight <linuxknight@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

please no private-only respones

Am 12.04.2017 um 16:52 schrieb linuxknight:
> Thanks you for the reply.  I was just examining the hardward in my
> server and it looks like there is an LSI card in there.  If I create a
> new Hardware raid mirror in that controller, is it possible to use the
> ddrescue to get my current OS onto that mirror and boot from it?  Im
> unfamiliar with the ddrescue but will certainly read up more.

"ddrescue" is at the end of the day the same as "dd"

it reads the whole drive block-by-block and writes it to a image file, 
later you can do "dd if=image.mig of=/dev/sdX bs=1M" and you get a 100% 
identical state of the disk

so just put out that drive, connect it to a ordinary SATA adapter, take 
the image and be happy that you have a backup, if the RAID-controller 
has stored whatever metadata on begin of the drive it's also part of the 
image

and hence leave out that controller to get a 100% block-by-block copy of 
the whole drive

> On Wed, Apr 12, 2017 at 10:45 AM, Reindl Harald <h.reindl@thelounge.net> wrote:
>>
>>
>> Am 12.04.2017 um 16:31 schrieb linuxknight:
>>>
>>> Last weekend I was moving a server with a raid1 configuration,
>>> controlled by a Intel Corporation 82801 SATA RAID Controller.  Upon
>>> reboot I noticed the degraded message (server hadnt been rebooted in a
>>> couple years).
>>>
>>> The raid1 array was two 500gb black WD drives.  I wasnt able to locate
>>> an identical 500gb disk, but did find a 2TB just to get things
>>> mirrored again.  The bios screen accepted the replacement disk and
>>> said it would rebuild in the OS.  mdsync seemed to do its thing but I
>>> noticed mdmon process was taking 200% cpu.  I let it go a few days
>>> thinking it was just taking longer than normal to sync, then rebooted.
>>> It was in a complete failed state and wouldnt boot at all.  After
>>> removing the 2TB disk I was able to boot into the OS again.  I just
>>> assumed I needed a similar drive size for the second part of the
>>> mirror.
>>
>>
>> when you talk about a "SATA RAID Controller" and "The bios screen accepted
>> the replacement disk and said it would rebuild in the OS" this sadly is not
>> a "linux software raid" at it's own
>>
>> 197 Current_Pending_Sector  -O--CK   200   200   000    -    9
>> 198 Offline_Uncorrectable   ----CK   200   200   000    -    7
>>
>> i would strongly suggest https://www.gnu.org/software/ddrescue/ and make a
>> image of that disk because after 39646 Power_On_Hours it's likely that the
>> remaining disk fails completly in a short time and you could at least
>> restore the disk-image with "dd" to a new disk if that happens as well as
>> mount it with as loop-device

