From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: performance problems with raid10,f2
Date: Tue, 25 Mar 2008 11:36:56 +0100
Message-ID: <20080325103656.GA4911@rap.rap.dk>
References: <20080314231151.GA14568@rap.rap.dk> <20080320172817.GA27070@rap.rap.dk> <18408.35320.92714.891870@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18408.35320.92714.891870@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 25, 2008 at 04:13:28PM +1100, Neil Brown wrote:
> On Thursday March 20, keld@dkuug.dk wrote:
> > On Sat, Mar 15, 2008 at 12:11:51AM +0100, Keld J=F8rn Simonsen wrot=
e:
> > > Hi
> > >=20
> > > I have a 4 drive array with 1 TB Hitachi disks, formatted as raid=
10,f2
> > >=20
> > > I had some strange observations:
> > >=20
> > > 1. while resyncing I could get the raid to give me about 320 MB/s=
 in
> > > sequential read, which was good. After resync had been done, and =
with
> > > all 4 drives active, I only get 115 MB/s.
> >=20
> > This was reproducable. I dont know what could be wrong.
>=20
> Is this with, or without, your patch to avoid "read-balancing" for
> raid10/far layouts?
> It sounds like it is without that patch ????
>=20
> NeilBrown

I tried both without the patch and with the patch, with almost same res=
ulte.
Is resync building some table, and could that be it?
Or could it be some time of inode traffic?

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
