From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Tue, 25 Sep 2012 10:55:39 -0600
Message-ID: <FABB1E4C-1CAC-429F-96CF-FC563336A913@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2286535.1cCOBDZvYY@techz> <505B736A-B9FE-4DB5-BA22-FEFDF1F9EE47@colorremedies.com> <5231765.ZMIFzBOKSc@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5231765.ZMIFzBOKSc@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 25, 2012, at 2:27 AM, G=FCnther J. Niederwimmer wrote:
>=20
>    Dirty State : dirty


Basically this is my only remaining concern, and while I don't know why=
 it's dirty, I think it needs to be resolved if you care about having R=
AID 1 in the first place. My best guess is that neither md on Linux nor=
 the IMSM driver on Windows have an unambiguous way to determine which =
disk is correct, which is why it hasn't just sync'd them. So you kinda =
have to pick one (?) and force a sync - again I'll have to defer to som=
eone else to answer that question but it's probably not ideal to just l=
eave it in a dirty state.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
