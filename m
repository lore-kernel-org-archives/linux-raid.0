From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Debugging a strange array corruption
Date: Tue, 14 Dec 2010 17:37:53 +0800
Message-ID: <4D073AF1.7090709@wasp.net.au>
References: <4D07265F.8060109@wasp.net.au> <20101214142246.20c927e1@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101214142246.20c927e1@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/12/10 17:22, Roman Mamedov wrote:
> On Tue, 14 Dec 2010 16:10:07 +0800
> Brad Campbell<brad@wasp.net.au>  wrote:
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

And in the prior incarnation I was only using 1 port on that controller so the problem would never 
have manifested itself. Thanks, at least I have something to try.

Regards,
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
