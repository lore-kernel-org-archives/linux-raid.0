From: =?utf-8?q?=C5=81ukasz_Ole=C5=9B?= <lukasz.oles@open-e.com>
Subject: Re: [Scst-devel] Tuning scst windows and sw raid5
Date: Fri, 22 Apr 2011 16:35:37 +0200
Message-ID: <201104221635.38092.lukasz.oles@open-e.com>
References: <201104221608.50195.lukasz.oles@open-e.com> <BANLkTiktSichu5PT7LUb0nLzOe=chq3s1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTiktSichu5PT7LUb0nLzOe=chq3s1A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Weiss <cweiss@gmail.com>
Cc: scst-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 22 of April 2011 16:19:48 you wrote:
> On Fri, Apr 22, 2011 at 9:08 AM, =C5=81ukasz Ole=C5=9B <lukasz.oles@o=
pen-e.com> wrote:
> > Hi,
> >=20
> > I'm trying to tune Software Raid5, SCST and Windows Initiator to ge=
t best
> > read/write performance.
>=20
> My first recommendation is to stick with blockio due to the raid5
> write hole possibility when using software raid.
>=20
> what windows version, and if not server2008, did you align the
> partitions? (there's a 2003 and a 2008 R2)
2008 R2

> dd is going to use the initiator OS's cache, make sure your test file
> size is 2x the ram in the initiator, if not the target too.
On initiator I have 2GB RAM and I'm copying 20GB file.

> Also xfs is much better at dealing with large files than ntfs.  Best
> apple to apples test is going to be on raw unformated partitions
What this test(testing on raw partitions) can tell me? In the end I hav=
e to=20
use filesystem.

> I'm not familiar with BST5.  I typically use iometer for both OS's.
I will try it.

--
Lukasz Oles

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
