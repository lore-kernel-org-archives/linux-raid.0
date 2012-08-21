From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: mdadm -add doesn't start rebuilding array
Date: Tue, 21 Aug 2012 09:25:15 +0100
Message-ID: <503345EB.4070408@debian.org>
References: <5032050A.4000801@supersystem.pl> <20120821083040.0d466ceb@notabene.brown> <50332E9E.6050108@supersystem.pl> <20120821182202.3ab1b22d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120821182202.3ab1b22d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?= <Sergiusz.Brzezinski@supersystem.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/08/12 09:22, NeilBrown wrote:
> On Tue, 21 Aug 2012 08:45:50 +0200 Sergiusz Brzezi=C5=84ski
> <Sergiusz.Brzezinski@supersystem.pl> wrote:
>=20
>>
>>
>> W dniu 21.08.2012 00:30, NeilBrown pisze:
>>> On Mon, 20 Aug 2012 11:36:10 +0200 Sergiusz Brzezi=C5=84ski
>>> <Sergiusz.Brzezinski@supersystem.pl>  wrote:
>>>
>>>> Hi,
>>>>
>>>> My system is Ubuntu 12.04, kernel 3.2.0-27. mdadm: 3.2.3
>>>>
>>
> lseek(4, 118783725568, SEEK_SET)        =3D 118783725568
> ioctl(4, BLKSSZGET, 0x7fff73de3fec)     =3D 0
> write(4, "bitm\4\0\0\0\267@qv.\210\307=3D,\205\351@\5\377~\6\303-\0\0=
\0\0\0\0"..., 512) =3D -1 EINVAL (Invalid argument)
>=20
>=20
> Oh, I remember now.  That bug.
> Fixed by commit 6ef89052d85b8137b8a7100f which is in 3.2.4.
>=20
> http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3D6ef89052=
d85b8137b8a7100f
>=20
> NeilBrown
>=20
>=20

Ubuntu 12.04 has 3.2.5-1ubuntu0.2 in updates pocket. Please update your
system and see if that helps?

--=20
Regards,
Dmitrijs.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
