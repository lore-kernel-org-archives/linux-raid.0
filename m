From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: performance problems with raid10,f2
Date: Thu, 20 Mar 2008 18:28:17 +0100
Message-ID: <20080320172817.GA27070@rap.rap.dk>
References: <20080314231151.GA14568@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080314231151.GA14568@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 15, 2008 at 12:11:51AM +0100, Keld J=F8rn Simonsen wrote:
> Hi
>=20
> I have a 4 drive array with 1 TB Hitachi disks, formatted as raid10,f=
2
>=20
> I had some strange observations:
>=20
> 1. while resyncing I could get the raid to give me about 320 MB/s in
> sequential read, which was good. After resync had been done, and with
> all 4 drives active, I only get 115 MB/s.

This was reproducable. I dont know what could be wrong.
I tried to enlarge my readahed, but the system did not allow me to have=
=20
more than a 2 MiB readahed, - well that should be ok for a 4 disk array
with 256 kiB chunks?

I did try to have chunks of 64 kiB - but no luck.

It seemed like it is something that the resync process builds up.
What could it be?

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
