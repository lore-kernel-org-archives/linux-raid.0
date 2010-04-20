From: Brett King <king.br@gmail.com>
Subject: Re: compute_blocknr: map not correct error during RAID6 reshape 6 ->
	7 disks, mdadm 3.1.2 / kernel 2.6.34-rc3
Date: Tue, 20 Apr 2010 13:43:08 +1000
Message-ID: <z2q8cf253381004192043haf99536cvfb2bf6fcfb40fa4d@mail.gmail.com>
References: <u2j8cf253381004151856l76b4e227mc6327534e0e304ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <u2j8cf253381004151856l76b4e227mc6327534e0e304ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
It's been quiet on this issue to date and I assume everyone's working
on important fixes and features etc - my apologies for the annoyance
however at this point I'm looking for some collective guidance on my
next move as I can't leave things in this state.

To summarize, I am attempting to grow a RAID6 array from 6 to 7x 2TB
disks however the reshape is stalling at 87.9% and throwing
'compute_blocknr: map not correct' errors. The system still responds
but needs a hard reset to do anything MD related.

I've tried varying kernel and mdadm versions all with the same result:
2.6.31, 2.6.33, 2.6.34-rc3 & rc4, each with mdadm 2.6.8, 3.0.2 &
3.1.2.

The only kernel source file containing this string is
drivers/md/raid5.c so I'm in the right place.

So I am asking you fellow linux-raid'ers, what can be done in this
situation ? I've filed a bug on bugzilla and now would only like to
know if this issue has been experienced by others, if perhaps a fix is
in the pipeline and any tips, tricks etc that may get the reshape
completed then the data accessible again.

I can see the only other non-destructuve option right now is to pull
out the disks, restore from backup onto a new array & wait for a
future kernel / mdadm version which will allow completion of the
reshape.

Cheers,
Brett.
