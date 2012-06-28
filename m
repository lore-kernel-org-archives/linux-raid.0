From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 17:56:39 +0200
Message-ID: <4FEC7EB7.1000401@xunil.at>
References: <4FE9BFC1.5070607@xunil.at> <20120628163205.2c6a1122@notabene.brown> <4FEC1CE7.5010709@xunil.at> <4FEC2071.8010504@xunil.at> <20120628212257.5ca8fb05@notabene.brown>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628212257.5ca8fb05@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 28.06.2012 13:22, schrieb NeilBrown:

>> Do I have to fear read-errors as with RAID5 now?
> 
> If you get a read error, then that block in the new devices cannot
> be recovered, so the recovery will abort.  But you have nothing to
> fear except fear itself :-)

Ah, yes. Not exactly raid-specific, but I agree ;-) (we have a poem by
Mischa Kaleko in german reflecting this, btw ...)

So if there is one non-readable block on the 2 disks I started with
(the degraded array) the recovery will fail?

As sd[ab]3 were part of the array earlier, would that mean that maybe
they bring the missing bit, just in case?


>> I still don't fully understand if there are also 2 bits of 
>> parity-informations available in a degraded RAID6 array on 2
>> disks only.
> 
> In a 4-drive RAID6 like yours, each stripe contains 2 data blocks
> and 2 parity blocks (Called 'P' and 'Q'). When two devices are
> failed/missing, some stripes will have 2 data blocks and no parity,
> some will have both parity blocks and no data (but can of course 
> compute the data blocks from the parity blocks). Some will have one
> of each.
> 
> Does that answer the question?

Yes, it does.

But ... I still don't fully understand it :-P

What I want to understand and know:

There is this issue with RAID5: resyncing the array after swapping a
failed disk for a new one stresses the old drives, and if there is one
read-problem on them the whole array blows up.

As far as I read RAID6 protects me against this because of the 2
parity blocks (instead of one) because it is much more unlikely that I
can't read both of them, right?

Does this apply to only a N-1 degraded RAID6 or also an N-2 degraded
array? As far as I understand, it is correct for both cases.

-

I faced this RAID5-related problem 2 times already (breaking the array
...) and therefore started to use RAID6 for the servers I deploy,
mostly using 4 disks, sometimes 6 or 8.

If this doesn't really protect things better, I should rethink that,
maybe.

-

Right now my recovery still needs around 80mins to go:

md0 : active raid6 sdb3[4](S) sda3[5] sdc3[2] sdd3[3]
      3903891200 blocks level 6, 64k chunk, algorithm 2 [4/2] [__UU]
      [================>....]  recovery = 83.0%
(1621636224/1951945600) finish=81.5min speed=67477K/sec

I assume it is OK in this state of things that sdb3 is marked as
(S)pare ...

Thanks, greetings, Stefan
