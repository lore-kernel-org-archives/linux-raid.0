From: Danilo Godec <danci@agenda.si>
Subject: Re: Multiple disk failure - recover?
Date: Wed, 10 Jul 2002 15:42:20 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0207101525130.25329-100000@duplo.agenda.si>
References: <02e301c22814$27779300$f6de11cc@black>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02e301c22814$27779300$f6de11cc@black>
To: Mike Black <mblack@csi-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 10 Jul 2002, Mike Black wrote:

> You don't say why two disks were kicked or when it happend so sdc may
> be out-of-whack a bit.  Sounds like sdc got kicked first.

I'm not 100% sure, but I think either of sda or sdb was the first
kicked... Dunno.

> So...I would do a bad-block scan on sdb2 so it can remap the bad
> section and re-build as you've been trying to do.

What tool would you use? I think that linux' badblocks operates on the FS
level... So it's useless on Software RAID5...

>
> If you REALLY want to use sda and sdc just rebuild the array with --create and leave sdb out of it.  You shouldn't lose much data if
> sdc is current.

I tried that and it simply ignores /dev/sda2...

I only need to recover as much data as possible. It's not that bad if I
loose yesterdays stuff.

   D.


