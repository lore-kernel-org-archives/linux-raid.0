From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Wrong checksumming function chosen
Date: Mon, 23 Sep 2002 09:46:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15758.22076.469462.721544@notabene.cse.unsw.edu.au>
References: <20020922135108.GA1441@uliweb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sebastian =?ISO-8859-1?Q?Sch=E4fer?= on Sunday September 22
To: Sebastian =?iso-8859-15?Q?Sch=E4fer?= <sarek@uliweb.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday September 22, sarek@uliweb.de wrote:
> Hi!
>=20
> It seems as my computer (Athlon XP 2000+) chooses the wrong checksumm=
ing
> function.
>=20
> The kernel output is as follows:
>=20
> raid5: measuring checksumming speed
>    8regs     :  2564.000 MB/sec
>    32regs    :  2260.000 MB/sec
>    pIII_sse  :  4748.400 MB/sec
>    pII_mmx   :  3921.200 MB/sec
>    p5_mmx    :  5022.400 MB/sec
> raid5: using function: pIII_sse (4748.400 MB/sec)
>=20
> I hope I can help the developers with this piece of information.
> And I also hope I mailed at the right address.

The only problem here is that the message is misleading.

pIII_sse is deliberately chosen despite appearing not to be so fast
because it avoid the level-1 cache which is appropriate for this data
which is only used by the CPU once.

NeilBrown


>=20
> Greets,
> --=20
> Sebastian Sch=E4fer
> E-Mail: sarek@uliweb.de || http://www.uliweb.de
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
