From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: Re: Is My Data DESTROYED?!
Date: Wed, 28 Oct 2009 10:50:45 +0100
Message-ID: <4AE813F5.9020107@cgv.tugraz.at>
References: <20091027143630.GF5585@boogie.lpds.sztaki.hu>	 <235564.59062.qm@web38801.mail.mud.yahoo.com> <7d86ddb90910271122p74827d2dr58de8bec9e20ef42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90910271122p74827d2dr58de8bec9e20ef42@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ryan Wagoner wrote:

> iSCSI is a block level protocol while NFS and Samba work at the file
> level. They all have their specific uses and advantages /
> disadvantages.
>=20
>> I wouldn't even consider NFS or Samba because they are ancient bloat=
ware.  I gather from a prior post that rsync has a remote ssh function.=
  If that's not the case then I guess it has to be sshfs.
>=20
> No NFS and Samba are not ancient bloatware. What other protocol would
> you use for a company file server? Rsync and SSH are not replacements
> for group file sharing.
>=20
> Just use rsync over SSH. Simple and reliable.

Openafs - http://www.openafs.org


MfG,
Lars Schimmer
- --
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkroE/UACgkQmWhuE0qbFyMUrQCdHe0IWxN48CRSsaYtdHppuj2y
gTkAoImQEOR10Cl20aQMPulrPCD4Yexp
=3Dcs7w
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
