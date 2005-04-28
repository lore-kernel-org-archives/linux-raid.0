From: "miele\@inwind\.it" <miele@inwind.it>
Subject: Re: Can you help me on Linux SW RAID?
Date: Thu, 28 Apr 2005 14:57:29 +0200
Message-ID: <IFNQNT$8C53F6787AC5A41F552611EC85CACF6C@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: lmb <lmb@suse.de>
Cc: jakob <jakob@unthought.net>, linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids

OK.

=46inally I can say that one solution is to have a disk array HW-RAID c=
ompliant.
:-)))


Anyway, omitting RAID features I think my nodes should correctly see th=
e same data on the shared disk array, using Oracle OCFS or RedHat GFS.
Do you agree?

Have you experienced problem using OCFS insetad of OCFS2??





> On 2005-04-28T13:41:45, "miele@inwind.it" <miele@inwind.it> wrote:
>=20
> > Obviously I've plan to use OCFS (Oracle Cluster File System) to sha=
re
> > data access between nodes...=0D
> > ..I've to implement an Oracle 9i RAC.
>=20
> OCFS2 is fine for that.=0D
>=20
> > You discourage anyway my use of RAID??
>=20
> md is NOT CLUSTER-AWARE. It will not work, and it will eat your data.
>=20
> You have been warned.
>=20
> Run the RAID level of your choice on the SAN backend, and put OCFS2 o=
n
> top.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>=20
> --=20
> High Availability & Clustering
> SUSE Labs, Research and Development
> SUSE LINUX Products GmbH - A Novell Business
>=20
>=20



____________________________________________________________
6X velocizzare la tua navigazione a 56k? 6X Web Accelerator di Libero!
Scaricalo su INTERNET GRATIS 6X http://www.libero.it


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
