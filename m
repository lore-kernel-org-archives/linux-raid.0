From: Andrea Mazzoleni <amadvance@gmail.com>
Subject: Re: Triple parity and beyond
Date: Sat, 23 Nov 2013 08:55:08 +0100
Message-ID: <CAGKKSfUejP=pb6HHF-48ciu5GSSd_ZCZMXHyL6iHLcQHvDs8yQ@mail.gmail.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<20131120222903.GA3654@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20131120222903.GA3654@lazy.lzy>
Sender: linux-btrfs-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, David Brown <david.brown@hesbynett.no>, David Smith <creamyfish@gmail.com>
List-Id: linux-raid.ids

Hi Piergiorgio,

> How about par2? How does this work?
I checked the matrix they use, and sometimes it contains some singular
square submatrix.
It seems that in GF(2^16) these cases are just less common. Maybe they
were just unnoticed.

Anyway, this seems to be an already known problem for PAR2, with an
hypothetical PAR3 fixing it:

http://sourceforge.net/p/parchive/discussion/96282/thread/d3c6597b/

Ciao,
Andrea
