From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: can't removed failed/detached drives when using metadata
 1.x
Date: Tue, 15 Feb 2011 11:05:10 +1100
Message-ID: <20110215110510.4e21d7ce@notabene.brown>
References: <4D54040C.4040201@lacie.com>
	<20110214142701.28950b00@notabene.brown>
	<4D5936A5.4010106@lacie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5936A5.4010106@lacie.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?B?UultaSBS6XJvbGxl?= <rrerolle@lacie.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 15:05:25 +0100 R=E9mi R=E9rolle <rrerolle@lacie.com=
> wrote:


> > Thanks for the report - especially for bitsecting it down to the er=
roneous
> > commit!
> >
> > This patch should fix the regression.  I'll ensure it is in all fut=
ure
> > releases.
> >
>=20
> Hi Neil,
>=20
> I've tested your patch with the setup that was causing me trouble. It=
=20
> did fix the regression.
>=20

Great - thanks for the confirmation.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
