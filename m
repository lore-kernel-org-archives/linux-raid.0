From: =?ISO-8859-1?Q?Jarmo_J=E4rvenp=E4=E4?=
	<Jarmo.Jarvenpaa@softers.net>
Subject: Re: RAID 5 questions
Date: Mon, 02 Aug 2004 09:55:20 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410DE558.6020203@softers.net>
References: <1091325475.2374.11.camel@localhost> <20040801033109.GA23032@jim.sh> <410DD8AA.6060609@softers.net> <20040802060810.GA20261@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040802060810.GA20261@percy.comedia.it>
To: Luca Berra <bluca@comedia.it>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hmm, we have 3 SW raid5 devices (md0, md1 and md3), with kernel on md0.=
=20
Lilo.conf has root and boot=3D/dev/md0. Lilo v22.3.1.




Luca Berra wrote:

> On Mon, Aug 02, 2004 at 09:01:14AM +0300, Jarmo J=E4rvenp=E4=E4 wrote=
:
>=20
>> Umm, I maybe writing on complitely different setup (can't check the=20
>> original post), but our server with software raid 5 (3 disks) is=20
>> booting with lilo just fine.
>=20
> check your setup, but your kernel is not on a raid 5 device.
>=20
> L.
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
