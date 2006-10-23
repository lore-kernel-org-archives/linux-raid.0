From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: why partition arrays?
Date: Mon, 23 Oct 2006 17:59:00 +0200
Message-ID: <ehios4$fvm$1@sea.gmane.org>
References: <20061018124225.GA23653@piper.madduck.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

martin f krafft <madduck@madduck.net> wrote:
> Why would anyone want to create a partitionable array and put
> partitions in it, rather than creating separate arrays for each
> filesystem? Intuitively, this makes way more sense as then the
> partitions are independent of each other; one array can fail and the
> rest still works -- part of the reason why you partition in the

Intuitively, especially the independence is a really mixed blessing.
First: If a disk fails somehow, md usually makes sure there is no
further access to it which could probably worsen the situation, i.e.
freeze busses, controllers, etc. Yes, this is a bit softened with the
new read-error-correction code, but IMHO still valid - and gets IMHO
even more and more valid with cheaper and cheaper controllers.
With multiple raids over partitions the disk is still a candidate to be
accessed subsequently.
Second: Bigger independence does also mean bigger concurrency. RAID1 for
example tries to equalize reads and directs reads to the mirror with
it's heads "closest" to the read-position (how good the "close"
estimation will ever be). Since partitions are somehow connected
together (especially by the disk's heads), concurrent access to multiple
RAIDs could torpedize this optimization. Perhaps this got a bit better
in 2.6, I don't know, in 2.4 you can watch this very well.


regards
   Mario
-- 
But after a while I learned the trick of speaking fast. You don't have
to think any faster; just use twice as many words to say everything.
                                -- Paul Graham

