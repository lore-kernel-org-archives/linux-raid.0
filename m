From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm raid5 and bit errors resync
Date: Wed, 24 Jun 2009 13:23:39 +1000
Message-ID: <19009.39995.508538.297396@notabene.brown>
References: <20090622055808.GN2828@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Ole Olsen on Monday June 22
Sender: linux-raid-owner@vger.kernel.org
To: Michael Ole Olsen <gnu@gmx.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday June 22, gnu@gmx.net wrote:
> what happens in the case of a single unrecoverable bit error when resyncing a
> raid5 or upgrading it?

During resync, a read error will cause the drive to fail and the
resync to abort.  So you get a degraded array.  On the next restart,
you will need to --force assemble the array because it will appear not
to be 'clean'.

What exactly do you mean by "uprade".

> 
> and in the case of raid6?

The same.

> 
> would raid6 only be able to survive 2 bit errors?

I don't understand why you are focussing on 'bit' error.  raid deals
with whole blocks, which either succeed or fail.
During resync you cannot trust the parity, so any read error means
lost data.
During recovery (to a hot spare) for a partially degraded raid6, the
correct data will be generated from the remaining good drives and
written out.

NeilBrown


> 
> couldn't really find any information on it in the docs or google, but I have
> heard about systems failing because of single bit errors.
> 
> /Michael Ole Olsen
