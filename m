From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: wait-option for assembly during boot process ?
Date: Mon, 24 Feb 2003 09:37:47 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15961.19771.328817.288090@notabene.cse.unsw.edu.au>
References: <3E58EEB3.30503@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Norman Schmidt on Sunday February 23
To: schmidt@naa.net
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday February 23, norman.schmidt@ratnet.stw.uni-erlangen.de wrote:
>=20
> But if the last shutdown left the md devices dirty, they are resynced=
=20
> during the next bootup while already in use. For normal ext2/ext3 dat=
a=20
> partitions, this is no problem, but for swap and possibly ext-3 journ=
als=20
> this is deadly.

Why do you think that resync is 'deadly' for 'swap and possibly ext-3
journals' ?

There were problems like this in 2.2, but they are long gone, unless
there is something else you are thinking of..

>=20
> What I would like to have is an option in mdadm.conf (through which t=
he=20
> arrays are configured and started automatically) like "WAIT" which ho=
lds=20
> up the boot process (i.e. usage of the not yet resynced devices) as l=
ong=20
> as resync takes. And these devices should be resynced first, so that =
one=20
> does not have to wait for the resync of a terabyte-big data array tha=
t=20
> uses part of the same disks.

There could be some value in atleast waiting until resync starts so
that the order of arrays will match the order of resync.

>=20
> How can I determine the order of assembly anyway? From top to bottom =
in=20
> the config file (at least for arrays that don=B4t share the same
> disks)?

Top to bottom.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
