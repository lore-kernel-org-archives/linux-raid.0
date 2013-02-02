From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Fri, 01 Feb 2013 20:24:06 -0500
Message-ID: <510C6AB6.8040900@turmel.org>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com> <20130201133455.GA24375@cthulhu.home.robinhill.me.uk> <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com> <20130201195734.GA16573@cthulhu.home.robinhill.me.uk> <510C5E3F.8090807@evilazrael.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510C5E3F.8090807@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/01/2013 07:30 PM, Christoph Nelles wrote:
[trim /]

>> If you're using standard desktop drives then you may be running into
>> issues with the drive timeout being longer than the kernel's. You need
>> to reset on or the other to ensure that the drive times out (and is
>> available for subsequent commands) before the kernel does. Most current
>> consumer drives don't allow resetting the timeout, but it's worth trying
>> that first before changing the kernel timeout. For each
>> drive, do:
>>     smartctl -l scterc,70,70 /dev/sdX
>>         || echo 180 > /sys/block/sdX/device/timeout
>>
> 
> Only the WDC Red supports that. The drives on the Marvell Controller all
> report
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled

First, the syntax should have had a backslash on the first line, so that
a failure on setting SCTERC would fall back to setting a 180 second
timeout in the driver.

Second, you list three Hitachi Deskstar 7k3000 drives as being on that
controller.  These have supported SCTERC in the past (I have some of
them) and this is the first I've seen where they don't.  Could you
repeat your smart logs, but with "-x" to get a full report?

> To be honest, I don't trust SMART much and prefer a write/read badblocks
> over SMART tests. But of course i won't do that on a disk which has data
> on it.

I've never found badblocks to be of use, but smart monitoring for
relocations is vital information.

Neither SMART nor badblocks will save you if you have a timeout
mismatch.  Enterprise drives work "out-of-the-box" as they have a
default timeout of 7.0 seconds.  Any other drives must have a timeout
set, or the driver adjusted.  Linux drivers default to 30 seconds--not
enough.

[trim /]

> I think I don't like this part of the  discussion ("That won't work").

I've gone back through your data, and part of the story is muddled by
the timeout mismatch.  Your kernel logs show "DRDY" status problems
before the drives are kicked out.  That suggests a drive still in error
recovery when the kernel driver times out, then not being able to talk
to the drive to reset the link.  Classic no-win situation with desktop
drives.

> I hope no question is left open

I didn't see anywhere in your reports whether you've tried "--assemble
--force".  That is always the first tool to revive an array that has
kicked out drives on such problems.

When you ran badblocks for 2 days, what mode did you use?

Your descriptions and kernel logs suggest that is /dev/sdg, but the
"mdadm --examine" reports show /dev/sdg was in the array longer than
/dev/sdj.  Please elaborate.

If you didn't destroy its contents, you should include it in the
"--assemble --force" attempt.  Then, with proper drive timeouts, run a
"check" scrub.  That should fix your UREs.

If you did destroy that drive's contents, you need to clean up the UREs
on the other drives with dd_rescue, then "--assemble --force" with the
remaining drives.

> Kind regards and thanks for all the help so far

I think it would be useful to provide a fresh set of "mdadm --examine"
reports for all member disks, along with a partial listing of
/dev/disk/by-id/ that shows what serial numbers are assigned to what
device names.

I don't think your situation is hopeless.

Phil
