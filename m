From: Matt Thrailkill <xwred1@modestolan.com>
Subject: Re: strange performance of raid0
Date: Sun, 15 Feb 2004 03:55:43 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1076846143.28006.14.camel@stoneburner.xwredwing.net>
References: <20040215100432.GA19002@rap.rap.dk>
	 <1076838850.28006.6.camel@stoneburner.xwredwing.net>
	 <20040215120525.GA19434@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040215120525.GA19434@rap.rap.dk>
To: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2004-02-15 at 04:05, Keld J=F8rn Simonsen wrote:
> I would have thought the disks would have worked towards gaining
> performance enhancements in some cumulative way, is that not so, in t=
heory?
>=20
> So why is 3 disks slower than 2?

Well, I'm not a complete guru so maybe I'm wrong, but in a stripe the
point is that you are pressing more platters into simultaneous service.=
=20
There's a certain amount of synchronization because the things your
computer needs at higher levels are spread across multiple disks, so it
wants them at about the same time.  If the first two disks provide the
data quickly and the third doesn't, the system probably will have to
wait for that third one before it can move on.

Thats my suspicion anyways.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
