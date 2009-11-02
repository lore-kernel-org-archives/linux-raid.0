From: Neil Brown <neilb@suse.de>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 13:28:25 +1100
Message-ID: <19182.17353.763258.508113@notabene.brown>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	<200911011241.40735.tfjellstrom@shaw.ca>
	<da6356c80d046663baad24dd41b6e989.squirrel@neil.brown.name>
	<200911011647.41259.tfjellstrom@shaw.ca>
	<cccedfc60911011553k42a27ee9u7a67b8410d781f57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Sunday November 1
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday November 1, jnelson-linux-raid@jamponi.net wrote:
> On Sun, Nov 1, 2009 at 5:47 PM, Thomas Fjellstrom <tfjellstrom@shaw.c=
a> wrote:
> > On Sun November 1 2009, NeilBrown wrote:
>=20
> >> Reshaping to a new chunksize is possible with the latest mdadm and
> >> =A0kernel, but I would recommend waiting for mdadm-3.1.1 and 2.6.3=
2.
> >> With the current code, a device failure during reshape followed by=
 an
> >> unclean shutdown while reshape is happening can lead to unrecovera=
ble
> >> data loss. =A0Even a clean shutdown before the shape finishes in t=
hat case
> >> might be a problem.
>=20
> Do you know if the stable series 2.6.31.XX incorporates the appropria=
te fixes?

They haven't been written yet.....
The kernel change is very small I think so it will go in to -stable.
But I want to write the mdadm changes first (which are bigger) and be
sure I don't need any other kernel changes.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
