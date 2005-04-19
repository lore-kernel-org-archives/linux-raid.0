From: Anu Matthew <anu.matthew@bms.com>
Subject: Re: Trouble assembling multipath md devices between two nodes who see
 the same LUNs.
Date: Mon, 18 Apr 2005 20:24:44 -0400
Message-ID: <11008ab4f.ab4f11008@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: en
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Larks. It is much appreciated.=20

If the original metadata written by hostA changes by "mdadm --assemble"=
 running on hostB, will mdmpd be able to recover the failed links on ho=
stA when they re-surface? I am asking this because, I guess unless host=
A goes down, hostA reflects the new metadata written by hostB. Will mdm=
pd take the new uuid into account?=20

Not entirely OT, but devabel gets to the see the same uuid/serial numbe=
rs on the shared luns across hosts. It would have been cool if mdadm co=
uld too, right?

Thanks,

Anu Matthew=20

<snip>
> On 2005-04-18T17:14:53, Anu Matthew=20
>=20
> md multipath has on-disk metadata and modifies it. md is NOT
> cluster-safe for concurrent activation.
>=20
>=20
> Sincerely,
>    Lars Marowsky-Br=E9e <lmb@suse.de>
>=20
> --=20
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business
</snip>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
