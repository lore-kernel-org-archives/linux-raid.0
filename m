From: 002@tut.by
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 06 Dec 2017 21:24:54 +0300
Message-ID: <3235751512584694@web9j.yandex.ru>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
         <1865221512489329@web5g.yandex.ru>
         <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
         <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
         <20171206104905.GA4383@metamorpher.de>
         <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
         <20171206160346.GA5806@metamorpher.de> <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Jeremy Graham <jeremy@doghouse.agency>, linux-raid@vger.kernel.org, Andreas Klauer <andreas.klauer@metamorpher.de>
List-Id: linux-raid.ids

> 
> No, almost certainly not the correct data. The data that was attempted
> to be written at the time the BB was added didn't make it to disk, and
> any future updated data writes would be skipped since it's in the list.

According to Neil's design notes, this is expected to happen only on members that had introduced write errors after last raid assembly.
According to my experience, on kernels at least up to v4.3, rewriting of member's bad blocks, that had already replicated to parity blocks, just fails with write error on file system level. I believe, Jeremy would have noticed if that happened to him, so, most certainly, the bad blocks hasn't been rewritten since. And if these are induced by read errors and not write errors (which is far more probable with most recent drives), the correct data is still there.

> No, it doesn't. The read error is only passed to the filesystem if
> there's no redundancy left for the block address.
Which is the case for every block here. Look at his BBL's.

> There's no "up" to the existing BBL. It isn't doing what people think.
> It does NOT cause the upper layer to avoid the block address. It just
> kills redundancy at that address.
Well, in a scenario with a completely lost (broken/unrecoverable) drive and expected occasional read errors on remaining raid members, even current state of BBL does more good then evil. Neil's design goals for the BBL feature looked perfectly valid back in 2010, only today they need amendment. As for the implementation itself, it is stable, but unfinished, lacking rewrite support (or is it not?) and a working reshape (probably just big fat warning in mdadm, that reshaping with non-empty BBL's is forbidden, because of potential data loss risk).

> This is why I suggested using hdparm to pass the BBL data to the
> underlying drive. Then MD *will* actually fix each block.
I don't believe the soft bad generation is a stable feature that produces repeatable and equal results on every drive. Also, you can't undo soft bad without rewriting sector. Risky advice. For raid5 it is trivial to xor sectors with the same numbers (plus data offset) to produce the correct missing sector and thus regenerate parity without relying on md doing this.
> 
> The problem with the BBL right now is its existence.
The tested implementation itself has a value. Though, I agree, BBL's absolutely shouldn't be turned on by default.

