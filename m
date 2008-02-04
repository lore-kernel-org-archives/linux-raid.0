From: Neil Brown <neilb@suse.de>
Subject: Re: /dev/sdb has different metadata to chosen array /dev/md1 0.91 0.90.
Date: Mon, 4 Feb 2008 11:41:45 +1100
Message-ID: <18342.24393.543507.149481@notabene.brown>
References: <79135625.20080202061254@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas-Sokov on Saturday February 2
Sender: linux-raid-owner@vger.kernel.org
To: Andreas-Sokov <andre.s@j8.com.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday February 2, andre.s@j8.com.ru wrote:
> =C7=E4=F0=E0=E2=F1=F2=E2=F3=E9=F2=E5, linux-raid.
>=20
> Help please, How i can to fight THIS :
>=20
> root@raid01:~# mdadm -I /dev/sdb
> mdadm: /dev/sdb has different metadata to chosen array /dev/md1 0.91 =
0.90.
>=20

Apparently "mdadm -I" doesn't work with arrays that are in the middle
of a reshape.  I'll try to fix that for the next release.

Thanks for the report.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
