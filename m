From: Neil Bortnak <linux-raid@moro.us>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs
	running
Date: Wed, 08 Feb 2006 04:18:44 +0900
Message-ID: <1139339924.25622.110.camel@fun-palace.bortnak.com>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
	 <43E68D62.4080704@cogweb.net>
	 <Pine.GSO.4.62.0602061105300.14030@shaka.acc.umu.se>
	 <43E77D35.1040905@cogweb.net>  <fd8d0180602060912q6181d52bs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180602060912q6181d52bs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: David Liontooth <liontooth@cogweb.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2006-02-06 at 18:12 +0100, Francois Barre wrote:
> A couple of years back in time, there were some tools to read and then
> rewrite floppy contents to remagnet the floppy content. I guess it
> shall be the same for the drive : periodically re-read and re-write
> each and every sector of the drive to grant a good magnetation of the
> surface.

I don't think this applies so much anymore. The coercivity of modern,
high-density magnetic media is quite a lot higher than that of floppy
disks. These days when you encode it, it really stays unless a very
strong magnetic force acts on it. Much stronger than that of any
household magnet.

That's why waving a big magnet over modern tapes doesn't actually do
anything to them (or so I'm told, I still need to test that, but I don't
use tape for backup anymore so I don't really have the materials handy).
The strength of the magnet is not powerful enough to overcome the
coercivity of the media. I don't know about those molybdenum magnets.
It's a problem in data remanance protection (ensuring that the data is
*really* gone on a hard disk).

Just to go OT for a second, doing one of those 32+ pass security wipes
won't necessarily protect you against a highly motivated attacker with a
scanning tunnelling microscope. This is because the data can be laid
down on a track, but the heads can move every so slightly (but still
well within tolerances) out of alignment. When you do your 32+ passes,
there is still a very small strip of the data left that can be
recovered.

The US military used to melt their drives into slag, but then EPA
regulations put a stop to that because of some of the more exotic
chemicals in the drive. Now they apparently use one of their 2.4MW
electomagnets for the job. Apparently the platters end up pressed
against the top of the drive. :)

Neil

