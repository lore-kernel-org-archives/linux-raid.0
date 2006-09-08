From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID5 fill up?
Date: Fri, 08 Sep 2006 14:15:08 +0400
Message-ID: <450142AC.8010304@tls.msk.ru>
References: <45013873.5040006@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45013873.5040006@cgv.tugraz.at>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Schimmer wrote:
> Hi!
>=20
> I=B4ve got a software RAiD5 with 6 250GB HDs.
> Now I changed one disk after another to a 400GB HD and resynced the
> raid5 after each change.
> Now the RAID5 has got 6 400GB HDs and still uses only 6*250GB space.
> How can I grow the md0 device to use 6*400GB?

mdadm --grow is your friend.

/mjt

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
