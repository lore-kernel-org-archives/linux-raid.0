From: Jure =?ISO-8859-2?Q?Pe=5Far?= <pegasus@nerv.eu.org>
Subject: Re: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 19:19:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025191900.713ae4b1.pegasus@nerv.eu.org>
References: <1098718593.5399.29.camel@duxeon.cobite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098718593.5399.29.camel@duxeon.cobite.com>
To: David Mansfield <md@dm.cobite.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 25 Oct 2004 11:36:33 -0400
David Mansfield <md@dm.cobite.com> wrote:

> 2) how can we force (or manually perform) a stripe-wise resync? is it
> possible to take the raid offline completely, read the data with dd,
> compute the parity manually, reassign the bad block using SCU and
> rewrite the parity block with dd then put the raid online again?

In raid5 there's no real need for that. When you add disk back into arr=
ay,
it should get fully resynced anyway.

I've written a short blurb in my blog about a rather rude method to han=
dle
misbehaving disks. Basically take it out of the array, run badblocks -w=
 on
it for a week and if it's ok, put it back :)


--=20

Jure Pe=E8ar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
