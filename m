From: g.esp@free.fr
Subject: Re: [PATCH 1/3] Align FAILED to test name to be parsable
Date: Tue, 23 Oct 2012 10:31:15 +0200 (CEST)
Message-ID: <975144635.322922429.1350981075121.JavaMail.root@zimbra33-e6.priv.proxad.net>
References: <20121023092356.1834e0a1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121023092356.1834e0a1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Mail original -----
> De: "NeilBrown" <neilb@suse.de>
> =C3=80: "g esp" <g.esp@free.fr>
> Cc: linux-raid@vger.kernel.org
> Envoy=C3=A9: Mardi 23 Octobre 2012 00:23:56
> Objet: Re: [PATCH 1/3] Align FAILED to test name to be parsable
>=20
> On Mon, 22 Oct 2012 10:31:23 +0200 (CEST) g.esp@free.fr wrote:
>=20
=2E..
> I've change the patch description and removed the change to the faile=
d
> message, because I don't want the log to appear in-line:
>=20
When using an automated build system (like I do in the linux from sourc=
es way), usually the last action is to remove the package source that w=
as just build. So that would remove any log needed to check the reasons=
 of the failures.

coreutils, after the test suite end, add all logs for failed and skippe=
d tests.
I think this is a good compromise.

Did you want that sort of behavior?


Gilles
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
