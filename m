From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: mdadm hotadd sync order
Date: Tue, 10 May 2005 15:44:59 +0200
Message-ID: <20050510134459.GE25070@marowsky-bree.de>
References: <20050510154003.574135b8@macinf5.ruca.ua.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050510154003.574135b8@macinf5.ruca.ua.ac.be>
Sender: linux-raid-owner@vger.kernel.org
To: SainTiss <saintiss@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-05-10T15:40:03, SainTiss <saintiss@gmx.net> wrote:

> Hi,
>=20
> how does mdadm determine which device to synchronize to which?
>=20
> For example, I have two partitions A and B which I would like to be s=
etup as a RAID-1 array.
>=20
> suppose A contains the data I want to have, and B contains rubbish. O=
bviously, I want B to be synched to A, and not the other way round.
>=20
> Suppose I do this:
>=20
> mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 A B

Create a degraded array with one missing disk with the good data; and
then add the one which you want to be overwritten.

> Or what would happen with the following?
> mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 missing B
> mdadm -a /dev/md0 A
>=20
> will A then sync to B because it was added last, or B to A because A =
fills the "missing" spot, which was specified before B?

B to A.

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
