From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Sat, 02 Feb 2013 01:30:55 +0100
Message-ID: <510C5E3F.8090807@evilazrael.de>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com> <20130201133455.GA24375@cthulhu.home.robinhill.me.uk> <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com> <20130201195734.GA16573@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130201195734.GA16573@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Robin,
hello Chris,

thanks for the help, the ideas and the discussion so far. And sorry for
the late response, i cam currently down with a cold.

Let me rollup the discussion so far with a little background:
One month ago, the RAID was expanded with the ninth HDD without any
rebuild problems. Last weekend I upgraded the server and kept only the
HDDs and a Marvell-based 4 Port SATA Controller. sda to sdf are
connected to the onboard AMD SB950, sdg-sdj to the Marvell controller
which has been always a little troublesome especially with Western Digitals.
Before adding or replacing a new HDD to the array, i always run a
badblocks write-read test on it, but of course this doesn't help when
blocks become bad over time.
I posted the kernel logs since the last reboot before the RAID failed at
http://evilazrael.net/bilder2/logs/kernel_20130202.log (8k lines, 600kb)
or http://evilazrael.net/bilder2/logs/kernel_20130202.log.gz (44kb)
The SMART logs are
http://evilazrael.net/bilder2/logs/smart_20130202.tar.gz if somebody is
curious. Yes, i roasted the Hitachis when i forget to plugin the cage fan.


After sdg was expelled the first time (Jan 28 00:23), I ran an extended
SMART test and then a read-write badblocks on it for almost 48hs. After
both found no errors I tried to readd it (Jan 30 18:19). And on Jan 31
00:34 the UREs broke the rebuild and kicked both drives :\

In the last two days I did a non-destructive badblocks on all devices,
only sdj reports some UREs consistently. After that i tried two
force-assembles. First broke on a read error on sdh. Then i retried and
this time the error on sdh didn't occur, but the later UREs on sdj
killed the rebuild.
At the beginning of the second try some automounter kicked in and
mounted the FS and I saw the contents of the FS, so at least the first
try didn't do additionally damage :-)

Tomorrow I will buy a new drive and dd_rescue sdj to the new drive.

And if that works then I will switch to RAID6 ASAP and check/replace all
other drives. If not, I won't need the drives anymore.

>> Also I'd like to know what model disks these are, if they're AF or >>
not.

/dev/sdb ST3000DM001-9YN1 CC4B (Seagate Barracuda 7200)
/dev/sdc WDC WD30EZRX-00M 80.0 (WDC Green SATA 3)
/dev/sdd WDC WD30EZRS-00J 80.0 (WDC Green SATA 2)
/dev/sde WDC WD30EFRX-68A 80.0 (WDC Red)
/dev/sdf WDC WD30EURS-63R 80.0 (WDC AV-GP)
/dev/sdg Hitachi HDS72303 MKAO (Deskstar 7k3000)
/dev/sdh Hitachi HDS72303 MKAO (Deskstar 7k3000)
/dev/sdi Hitachi HDS72303 MKAO (Deskstar 7k3000)
/dev/sdj WDC WD30EZRX-00M 80.0 (WDC Green SATA 3)

AV-GP and Red are marketed as 24/7 and RAID-capable, but the
availability was bad.

> If you're using standard desktop drives then you may be running into
> issues with the drive timeout being longer than the kernel's. You need
> to reset on or the other to ensure that the drive times out (and is
> available for subsequent commands) before the kernel does. Most current
> consumer drives don't allow resetting the timeout, but it's worth trying
> that first before changing the kernel timeout. For each
> drive, do:
>     smartctl -l scterc,70,70 /dev/sdX
>         || echo 180 > /sys/block/sdX/device/timeout
> 

Only the WDC Red supports that. The drives on the Marvell Controller all
report
SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled


To be honest, I don't trust SMART much and prefer a write/read badblocks
over SMART tests. But of course i won't do that on a disk which has data
on it.

>>>> Yes, if sdg still contains valid array data (and the array
>>>> wasn't
>>> written since then) then it would definitely make more sense to
>>> recreate the array using it, leaving sdj out for now. That'll
>>> require more work checking mdadm versions and data offset values
>>> though. That'll avoid the issues with the unreadable blocks on
>>> sdj.
>> 
>> Here's an idea. One possibility is to use dd to read the sector on 
>> sdg1 that error1.txt reported with the write error, to a file, and
>> see if there's a read error. If not, rewrite that data back to the
>> same sector and see if there's a write error. If not, attempt to
>> force assemble assume clean, get the array up in degraded mode, and
>> do a non-destructive fsck. If that's OK, just take a backup
>> immediately. Then sdj can be destructively written to, to force bad
>> sectors there to be removed for reserves, but still needs a smart
>> extended offline test to confirm; and then possibly reused and
>> rebuilt.
>> 
> That won't work. He's already lost the metadata on sdg1 by trying to 
> rebuild it in the first place, so a force assemble won't work. He'd
> need to recreate the array instead. Otherwise yes, that would sound
> to be the best option (assuming there's no other read errors on the
> other disks).


I think I don't like this part of the  discussion ("That won't work").


I hope no question is left open



Kind regards and thanks for all the help so far

Christoph


Am 01.02.2013 20:57, schrieb Robin Hill:
> On Fri Feb 01, 2013 at 10:27:57 -0700, Chris Murphy wrote:
> 
>>
>> On Feb 1, 2013, at 6:34 AM, Robin Hill <robin@robinhill.me.uk> wrote:
>>> It'd also be useful to know whether sdg has been rewritten at
>>> all since then (i.e. whether the testing was destructive or not), and
>>> whether or not the array was written to at all since the failure of sdg.
>>
>> OP needs to reply back.
>>
>>
> 
> Cheers,
>     Robin


-- 
Christoph Nelles

E-Mail    : evilazrael@evilazrael.de
Jabber    : eazrael@evilazrael.net      ICQ       : 78819723

PGP-Key   : ID 0x424FB55B on subkeys.pgp.net
            or http://evilazrael.net/pgp.txt

