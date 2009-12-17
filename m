From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 19:36:31 -0600
Message-ID: <03.19.01470.02B892B4@cdptpa-omtalb.mail.rr.com>
References: <70ed7c3e0912160321m39861a1ex84de114dc9a6b961@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912160321m39861a1ex84de114dc9a6b961@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Oh, I thought this was a backup system. I always ramp up the speed on
> min & max to have the resync & reshapes finish fast, but at the loss
> of performance during that.

	One of them, the one resyncing right now, is a backup system.  When
it is done, I will grow the main server.  I don't want to have both
performing potentially sensitive operations simultaneously.

> You mentioned that you've unmounted the filesystem, so why does it
> make a different if you max the speed? Or do you have other services
> running?

	It probably doesn't matter on the backup, but the point is I would
rather not have it unmounted for the better part of 5 days.  I would rather
not go nearly 5 days without a valid backup, if I can avoid it.  Ordinarily
rsync runs every morning.

> I think at the time I needed a new mdadm, I downloaded 3.0 which is
> the stable one for now (3.1 was pulled -- donno about 3.1.1).

	Unless there is some compelling reason to download 3.0, I think I
will wait for it to be included in the stable distro of Debian.

