From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: How can I tell what drive is sdb?
Date: Thu, 28 Jan 2010 01:00:36 -0800 (PST)
Message-ID: <640128.89077.qm@web51302.mail.re2.yahoo.com>
References: <1264601024.29409.19.camel@thor>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264601024.29409.19.camel@thor>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Rick Bragg <lists@gmnet.net>
List-Id: linux-raid.ids

--- On Wed, 27/1/10, Rick Bragg <lists@gmnet.net> wrote:

> From: Rick Bragg <lists@gmnet.net>
> Subject: How can I tell what drive is sdb?
> To: linux-raid@vger.kernel.org
> Date: Wednesday, 27 January, 2010, 14:03
> Hi,
>=20
> I have a system with raid10 running Ubuntu 8.10.=A0 It
> uses a
> "promise"card
>=20
> # lsusb
> ..
> 01:02.0 Mass storage controller: Promise Technology, Inc.
> PDC40718 (SATA
> 300 TX4) (rev 02)
> ..
>=20
> I have 4 identical disks on it and they show up as
> /dev/sda, b, c, and
> d.
>=20
> However, sdb needs to be replaced.=A0 How can I tell
> which drive is sdb?
> Is there a way to identify what drive is what?
>=20
> Thanks
> Rick
>=20

I had this problem, and and as it is a mare removing the drives to iden=
tify what one is what.. When i needed to reorganise my physical drive o=
rder i took the liberty of writing on the sides/back of each drive a sh=
ort incrementing ID that tallys to a spreadsheet of serial numbers that=
 i gleaned from smartctl.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
