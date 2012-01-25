From: Andrei Warkentin <awarkentin@vmware.com>
Subject: Re: LVM striping RAID volumes
Date: Wed, 25 Jan 2012 12:59:36 -0800 (PST)
Message-ID: <274466957.91999.1327525176550.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <20256.2521.77580.864903@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20256.2521.77580.864903@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

H Peter,

----- Original Message -----
> From: "Peter Grandi" <pg@lxra2.to.sabi.co.UK>
> To: "Linux RAID" <linux-raid@vger.kernel.org>
> Sent: Wednesday, January 25, 2012 8:55:37 AM
> Subject: Re: LVM striping RAID volumes
>=20
> It would be nice if MD passed on TRIM or at least FITRIM, and I
> have just done a search and there is a discussion of some issues
> with that here:
>=20
> http://lkml.indiana.edu/hypermail/linux/kernel/1011.2/02184.html
>=20
>  =C2=ABthe only really complex part is sending something like that
>   into MDraid, because that one set of ranges might explode into
>   thousands of ranges and then have to be coalesced back down to
>   a more manageable number of ranges.
>=20
>   ie. with a simple raid 0, each range will need to be broken
>   into a bunch of stride sized ranges, then the contiguous
>   strides on each spindle coalesced back into larger ranges.
>=20
>   But if MDraid can handle discards now with one range, it
>   should not be that hard to teach it handle a group of ranges.=C2=BB
>=20
> This perplexes me because the logic should be identical to that
> of writing: TRIM is in effect a variant of WRITE.
> --

That comment perplexes me as well. Who cares how many TRIMs go down int=
o the
slave devices? My understanding is that it was the drive's job to figur=
e out
TRIM-coalescing on it's own - the block queue limits at the very least =
specify a "max discard"
size, not a minimum one. (btw FITRIM is an fs ioctl afaik, it gets tran=
slated into
REQ_DISCARDs).

Anyway, I was just looking at supporting REQ_DISCARD within RAID1. I do=
n't see it being
any different than handling other BIO flags like REQ_FUA etc. The only =
bit to watch out
for are not sending DISCARDs to a device which doesn't support them. I =
was looking at
discard as part of some other investigation which I will write about at=
 a later point, but
if there was specific interest, I could refactor it out and post it for=
 review.

A
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
