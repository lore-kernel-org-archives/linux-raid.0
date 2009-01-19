From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Performance question
Date: Mon, 19 Jan 2009 19:12:53 +0100
Message-ID: <20090119181253.GA4290@lazy.lzy>
References: <20090117171806.GA9432@lazy.lzy> <20090117220849.GB29866@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090117220849.GB29866@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

thanks for the answer, that was exactly what I
was looking for.

Some feedback for you.
About the performance & benchmarking I've nothing
special to say.
About the setup of two disks, I've some questions,
in no particular order.

The creation of "mdadm.conf" is done by:

mdadm --detail --scan

Somewhere else I found:

mdadm --examine --scan

The two produce different results and the Fedora
installer seems to use the second one.

Which one is really correct? Can we use one or the
other interchangeably?

Second question.
The wiki page does not mention anything about
metadata types.
While it is clear that /boot must have the RAID
header at the end, it is not clear if the RAID-10,f2
could or should have the metadata at the beginning.
In this respect, it would be nice also to have some
clarification about the reccommended metadata version,
i.e. is it better 0.90 or 1.x? Why?

One note. Maybe it could be worth to mention that
further "partitioning" could be done with LVM on top
of the RAID, so only 3 md devices will be needed.

Hope this helps.

Thanks again,

bye,

pg

On Sat, Jan 17, 2009 at 11:08:49PM +0100, Keld J=F8rn Simonsen wrote:
> On Sat, Jan 17, 2009 at 06:18:06PM +0100, Piergiorgio Sartor wrote:
> > Hi all,
> >=20
> > I'll have to setup some machines with two HDs (each)
> > in order to get some redundancy.
> >=20
> > Reading the MD features I noticed there are several
> > possibilities to create a mirror.
> > I was wondering which one offer the best perfomances
> > and/or what are the compromises to accept between
> > the different solutions.
> >=20
> > One possibility is a classic RAID-1 mirror.
> > Another is a RAID-10 far.
> > There would also be the RAID-10 near, but I guess
> > this is equivalent to RAID-1.
>=20
> Yes, raid10,n2 is quite the same as raid1 for 2 drives,
> That is the disk layout is the same. There may be some=20
> differences due to the use of different drivers, tho. It was reported=
 at
> some time that there were some errors that one of the drivers handled
> better than the other. I am not sure which one was the better.
> Also syncing and rebuilding etc. may have different performance.
>=20
> > Any suggestion on which method offers higher "speed"?
> > Or there are other possibilities with 2 HDs (keeping
> > the redundancy, of course)?
>=20
> raid10,f2 offers something like double the speed for sequential read,
> while probably being a little faster on random read, and with a file
> system about equal in performance on writes. Degraded performance (in
> tha case that one disk is failing) could be worse for raid10,f2, but =
in
> real life, with the fs elevator in operation, the penalty may be
> minimal. IMHO you could normally replace raid1 and raid10,n2, and
> raid1+0 with raid10,f2, except for boot devices.
>=20
> Theoretically there is another possibility in raid5 with 2 drives,
> but I am not sure it even works out in practice, and there is imho no
> gain in it, except that you can expand the array with more disks.
> Furthermore there is raid10,o2 which is viable, but does not
> perform as well as raid10,f2.
>=20
> For linux raid performance have a look at
> http://linux-raid.osdl.org/index.php/Performance
>=20
> For setting up a system with 2 disks so you can survive that one disk
> fails, see
> http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_dis=
k
>=20
> I am the main author of both wiki pages, so I am interested in feedba=
ck.
>=20
> Best regards
> Keld

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
