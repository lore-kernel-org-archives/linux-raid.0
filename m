From: Mike Hardy <mhardy@h3c.com>
Subject: Re: MegaRaid problems..
Date: Thu, 12 Oct 2006 06:15:51 -0700
Message-ID: <452E4007.1080206@h3c.com>
References: <200609241503.09808.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0609241829100.17345@coffee.psychology.mcmaster.ca> <Pine.LNX.4.56.0610120913480.11816@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0610120913480.11816@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:
> This might not be strictly on-topic here, but you may provide
> enlightenment, as a lot of web searching hasn't helpmed me so-far )-:
> 
> A client has bought some Dell hardware - Dell 1950 1U server, 2 on-board
> SATA drives connected to a Fusion MPT SAS controller. This works just
> fine. The on-board drives are mirrored using s/w RAID, which is great and
> just how I want it.
> 
> The server also has 2 x Dell PERC dual-port SAS Raid Cards which have LSI
> MegaRaid chipssets on them. One cable from each raid card connect to half


> this is 2.6.18), and at boot time the dmesg output sees the drives in the
> external enclosure, but does not associate them to sdX drives! The
> underlying distro is Debian stable, but I doubt theres anything of issue
> there.

I have several Dell 2950s (same chassis) and they have this problem.

You can't do the PERC card and get JBOD basically. The PERC5 card has no
JBOD mode, whereas the PERC4 card did.

Dell said they may get a BIOS update, but wouldn't commit.

In the meantime, you have to exchange the PERC5 card for a SAS5 card,
then you can have JBOD.

I was a little disappointed, as the PERC5 card can drive 6 or 8 devices,
but the SAS5 card can only drive 4. Lame.

-Mike
