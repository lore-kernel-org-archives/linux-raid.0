From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Booting off of RAID10 versus RAID1
Date: Sun, 11 May 2008 09:28:52 +0200
Message-ID: <20080511072852.GA20335@rap.rap.dk>
References: <48230154.4000509@harddata.com> <20080508144016.GB15607@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080508144016.GB15607@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 08, 2008 at 04:40:16PM +0200, Keld J=F8rn Simonsen wrote:
> On Thu, May 08, 2008 at 07:34:12AM -0600, Maurice Hilarius wrote:
> > After recent issues discovered with RAID1 and failing disks, I am=20
> > contemplating alternatives to ensure more reliability.
> >=20
> > The question that arises: Is there any way to boot a system from a=20
> > RAID10 md?
>=20
> I believe you can boot off a raid10,n2 array.

You should also be able to boot off a raid5 array with 2 disks!

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
