From: "Potthoff, Kay" <Kay.Potthoff@force.de>
Subject: RE: /proc/mdstat output
Date: Thu, 23 May 2002 14:06:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <9CFB9DA5261CD611A29B00508B789048654305@ex-deu-munich02.force.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Rene Scherer' <rene@scherer-online.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Rene Scherer [mailto:rene@scherer-online.com]
> Sent: Donnerstag, 23. Mai 2002 12:54
> To: linux-raid@vger.kernel.org
> Subject: /proc/mdstat output
>=20
>=20
> Hi all
>=20
> I've got a small question about the output of "cat /proc/mdstat"
>=20
> I've got 3 RAIDs configured (RAID-1 mirror), md0, md1 and md2
> When I run "cat /proc/mdstat", I get the following output:
>=20
> Personalities : [raid1]
> read_ahead 1024 sectors
> md1 : active raid1 sdb2[1] [dev 08:02][0]
>       10241344 blocks [2/2] [UU]
>=20
> md2 : active raid1 sdb3[1] [dev 08:03][0]
>       38130176 blocks [2/2] [UU]
>=20
> md0 : active raid1 sdb1[1] [dev 08:01][0]
>       10241280 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20

It seems that the first partition is shown as [dev 08:02][0], which is
/dev/sda2 (for example). I have no idea why the name is not listed.

Regards, Kay

######################################################
# Kay Potthoff              Senior Software Engineer
#
# FORCE Computers GmbH        Tel.: +49-89-60814-356
# Prof.-Messerschmitt-Str. 1       FAX : +49-89-6097793
# 85579 Neubiberg/M=FCnchen
# Deutschland/Germany
#
# mailto:Kay.Potthoff@force.de
######################################################
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
