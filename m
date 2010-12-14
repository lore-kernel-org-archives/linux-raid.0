From: "David W." <darewi@gmail.com>
Subject: Re: Debugging a strange array corruption
Date: Tue, 14 Dec 2010 05:59:17 -0600
Message-ID: <AANLkTikpQ822E0BQqDhGcDvcvK5c+odW-w1DRfAkTMmX@mail.gmail.com>
References: <4D07265F.8060109@wasp.net.au>
	<20101214142246.20c927e1@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101214142246.20c927e1@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Brad Campbell <brad@wasp.net.au>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 14, 2010 at 03:22, Roman Mamedov <roman@rm.pp.ru> wrote:
> On Tue, 14 Dec 2010 16:10:07 +0800
> Brad Campbell <brad@wasp.net.au> wrote:
>
>> The drives are all on separate channels. 8 are on a pair of Marvell 88SX7042
>> controllers and 2 are on a SIL3132. This has occurred since I upgraded the
>> mainboard (and kernel at the same time - nothing like throwing more
>> variables in the mix) and its effects were subtle enough that I missed them
>> until it had successfully rotated out all of my good backups with broken
>> data. Lesson learned.
>
> I'd suggest that you try moving two disks away from SiI3132, change your
> setup so that at most ONE port on that controller is used, or none at all.
>
> Some time ago there was a report of data corruption with controllers using
> that chip when both ports simultaneously read at full speed:
> http://forum.ixbt.com/topic.cgi?id=11:35147:1200#1200 (in Russian)
> Perhaps problem not in the chip itself, but in some variations of
> schematics/components/soldering, because only two of five supposedly identical
> boards the reporter bought were corrupting data in that way, one much
> more often than the other.
>

Interesting... Any idea if the problem affects the SiI 3114 chipset as
well?  I've been seeing some similar problems, but haven't had enough
time to dig into it to query the list yet.

--
david williams
<darewi@gmail.com>
