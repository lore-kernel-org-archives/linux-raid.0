From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 - RAID6
Date: Mon, 8 Mar 2010 02:59:07 -0600
Message-ID: <B8.32.23425.F5CB49B4@cdptpa-omtalb.mail.rr.com>
References: <4877c76c1003071931q4ede50c6p754e5478b07f2533@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003071931q4ede50c6p754e5478b07f2533@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Evans' <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Yes, it is for Squeeze, if you want the latest bugfixes and security
> updates you should seriously consider running debian-testing instead
> of stable.

	No, thanks.  I loaded "Squeeze" on another non-RAID workstation in
order to alleviate a kernel bug causing problems with a 3G wireless modem.
It was quite unstable, and caused a number of issues, most problematically
with the fact the distro assumes the system is not headless and would lock
up tight on boot if no monitor is present.  All of the RAID systems are
headless.  More importantly, stability is far and away the absolutely most
important requirement for these servers.  New features I can live without.
Bug fixes I don't need unless they directly affect the functioning of the
system, which is highly focussed.  These systems have a handful of very
basic, very mature apps.  They run NTP, FTP, SSH, rsync, NUT, SMART, SAMBA,
NFS, and KDE.  One of them also runs Galleon, pyTivo, TyTool under wine, and
openvpn server.  That's it.

> Stable is reserved for 'mature' features.  Testing, as far
> as I'm aware, will almost never (and should never if you are paying
> attention) cause data-loss, but might occasionally get in to a
> situation where something breaks; mostly just during upgrades (but
> then that's true of any upgrade).

	It's true no data was lost, but then it's a little difficult to lose
data if the system hangs hard on boot.  I had to yank most of the guts out
of the system to get it stable.  That, plus the new version of KDE really
sucks badly, and I could not get Kpackage to work properly at all.  It also
did something really goofy to pppd, but I was able to work around it by
re-trying the pppd launch repeatedly on boot until it works.

