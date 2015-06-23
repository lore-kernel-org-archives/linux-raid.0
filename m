From: Phil Turmel <philip@turmel.org>
Subject: Re: (R) in mdstat output, clean && degraded
Date: Tue, 23 Jun 2015 18:09:28 -0400
Message-ID: <5589D918.9000401@turmel.org>
References: <51364598-D6AA-43E7-B9A1-C3C09255D3D4@puck.nether.net> <5589BDCA.5050801@turmel.org> <F30009F6-7BF5-4786-A3A6-04C5C49B8E0C@puck.nether.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F30009F6-7BF5-4786-A3A6-04C5C49B8E0C@puck.nether.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jared Mauch <jared@puck.nether.net>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 06/23/2015 05:21 PM, Jared Mauch wrote:
> Let me know what debugging/details might be interesting to collect. =20

A good sequence of events (from bash history perhaps) with correspondin=
g
log messages is always helpful.  Your initial report was pretty good.

> Based on the Events# being in-sync, I am going to assume that the dri=
ves
> may be operating in a protected-type mode even if the output doesn=E2=
=80=99t
> concur.

I think that's unlikely.  In replace, one drive responds for sectors
below the progress mark, and the other drive responds for sectors above=
 it.

> I can say this state seems to survive reboots.

That suggests you give a vanilla (or near-vanilla) kernel a try with on=
e
of the various liveCDs that have them.  I personally find the one from
sysrescuecd.org to be most convenient, but I'm a gentoo guy :-)

Otherwise, consider adding a third drive to see if it will rebuild and
break the deadlock.

I should have to say, but I hope you have a backup :-)

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
