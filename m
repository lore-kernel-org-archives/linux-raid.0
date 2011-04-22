From: NeilBrown <neilb@suse.de>
Subject: Re: change from raid 5 to raid 6 interrupted
Date: Sat, 23 Apr 2011 08:06:13 +1000
Message-ID: <20110423080613.14189094@notabene.brown>
References: <BANLkTikntFUK5rX1oTynY849=o-GuDL2Yg@mail.gmail.com>
	<BANLkTikBscshav-eDHHAGWh=6iuDMj=b0w@mail.gmail.com>
	<4DB1991D.1090902@anonymous.org.uk>
	<BANLkTi=4i67qxZ9ymD+VpuCszPzby57d8w@mail.gmail.com>
	<4DB19D67.1040809@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB19D67.1040809@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Raphael =?ISO-8859-1?B?TfxsbGVy?= <rapmue@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 22 Apr 2011 16:23:19 +0100 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> (Please always remember to cc the list when replying; cc readded)
>=20
> On 22/04/2011 16:09, Raphael M=FCller wrote:
> > Ok i forgot to say, that the backup file is also gone... (my mistak=
e)
> >
> > is this backup file the only option i got?
>=20
> Without the backup file you've almost certainly lost some data. I=20
> suspect there is a way of restarting the array and reshape without th=
e=20
> backup file, but I don't know what it is - you'll have to wait for a=20
> proper guru to get back to you with an answer.
>=20

With mdadm 3.2.1 there is a new flag "--invalid-backup".  It tells mdad=
m that
you know that the backup file is invalid, but you want it to continue a=
nyway
(and risk having some corrupted data).

You still need to give a backup file, but it can be a newly created emp=
ty
file.

So:
  # install mdadm 3.2.1
  > /root/my-backup
  mdadm -A /dev/mdthing --backup-file=3D/root/my-backup  \
  --invalid-backup /dev/device1 /dev/device2 ....

should get you going again.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
