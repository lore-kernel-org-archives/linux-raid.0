From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 01:17:29 +0100
Message-ID: <20080130001729.GB7975@rap.rap.dk>
References: <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <20080129202156.GA32434@rap.rap.dk> <479FA540.70707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479FA540.70707@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 04:14:24PM -0600, Moshe Yudkowsky wrote:
> Keld J=F8rn Simonsen wrote:
>=20
> Based on your reports of better performance on RAID10 -- which are mo=
re=20
> significant that I'd expected -- I'll just go with RAID10. The only=20
> question now is if LVM is worth the performance hit or not.

Hmm, LVM for what purpose? For the root system, I think it is not=20
an issue. Just have a large enough partition, it is not more than 10- 2=
0
GB anyway, which is around 1 % of the disk sizes that we talk about
today with new disks in raids.

> >I would be interested if you would experiment with this wrt boot tim=
e,
> >for example the difference between /root on a raid5, raid10,f2 and=20
> >raid10,o2.
>=20
> According to man md(4), the o2 is likely to offer the best combinatio=
n=20
> of read and write performance. Why would you consider f2 instead?

I have no experiences with o2, and little experience with f2.
But I kind of designed f2. I have not fully grasped o2 yet.=20

But my take is that for writes, this would be random writes, and that i=
s
almost the same for all layouts. However, when/if a disk is faulty, the=
n=20
f2 has considerably worse performance for sequential reads,
approximating the performance of random reads, which in some cases is
about half the speed of sequential reads. For sequential reads and
random reads I think f2 would be faster than o2, due to the smaller=20
average seek times, and use of the faster part of the disk.

I am still wondering how o2 gets to do striping, I don't understand it
given the layout schemes I have seen. F2 OTOH is designed for striping.

I would like to see some figures, tho. My testing environment is, as
said, not operationable right now, but will be OK possibly later this
week.

> I'm unlike to do any testing beyond running bonnie++ or something=20
> similar once it's installed.

I do some crude testing like reading concurrently 1000 files of 20 MB,=20
and then just cat file >/dev/null of a 4 GB file. The RAM caches needs
to be not capable of holding the files.

Looking on boot times could also be interesting. I would like as litte
downtime as possible.

But it depends on your purpose and thus pattern of use. Many systems
tend to be read oriented, and for that I think f2 is the better
alternative.

best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
