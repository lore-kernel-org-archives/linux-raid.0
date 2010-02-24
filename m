From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 16:32:12 +0100
Message-ID: <4B85467C.5020008@xunil.at>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 24.02.2010 16:22, schrieb Robin Hill:
> On Wed Feb 24, 2010 at 04:05:36PM +0100, Stefan G. Weichinger wrote:
> 
>> Am 24.02.2010 15:54, schrieb Stefan G. Weichinger:
>>
>>> What to try?
>>>
>>> This is a crucial server and I feel a lot of pressure.
>>> Rebuilding that raid would mean a lot of restore-work etc.
>>> So I would really appreciate a goo advice here.
>>
>> Followup:
>>
>> --examine shows different statii for the four partitions:
>>
> Hmm, that looks like sda4 dropped out after sdc4 was removed, failing
> the array.  Can you force assemble the array?
>     mdadm -A /dev/md4 -f /dev/sda4 /dev/sdb4
> 
> If that works, you'll want to re-add the hot spare so it rebuilds.
> You'll also need to fsck the filesystem afterwards.

I thank you a lot for this piece of help.
I always hesitate to TRY things in such a situation as I once back then
dropped a RAID by doing the wrong thing.

The md4 is UP again on 2 spindles, 3rd re-added right now.

Looks promising.

THANKS, I owe you something.

I report back later with more details ...

S
