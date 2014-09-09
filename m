From: NeilBrown <neilb@suse.de>
Subject: Re: Question about RAID1 plug/unplug code
Date: Tue, 9 Sep 2014 19:45:32 +1000
Message-ID: <20140909194532.621f4500@notabene.brown>
References: <CAGRgLy4WTXdF4Tp1pf0BJ-VPR3Yhx_xyzbCAXBzNDpeYTPvkmw@mail.gmail.com>
	<20140909114538.552a4a7d@notabene.brown>
	<CAGRgLy4QAz6KVncLsVypsOD85jMUNaOgrFc13=knHMXb92SvXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/A8SfSBkFhpmJ/CPc9JQAFDA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4QAz6KVncLsVypsOD85jMUNaOgrFc13=knHMXb92SvXw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Yair Hershko <yair@zadarastorage.com>
List-Id: linux-raid.ids

--Sig_/A8SfSBkFhpmJ/CPc9JQAFDA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Sep 2014 11:33:13 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
>=20
> On Tue, Sep 9, 2014 at 4:45 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 8 Sep 2014 16:55:52 +0300 Alexander Lyakas <alex.bolshoy@gmail.=
com>
> > wrote:
> >
> >> Hi Neil,
> >> We have been seeing high latency on the md/raid1 block device, due to
> >> the fact that all WRITEs are handed off to raid1d thread. This thread
> >> also calls bitmap_unplug(), which writes the bitmap synchronously.
> >> While it waits for the bitmap, it cannot trigger other WRITEs waiting
> >> in its pending_bio_list. This is especially seen with SSDs: MD's
> >> latency is much higher that SSD latency (I have been stoned by Peter
> >> Grandi when I brought up this issue previously for raid5).
> >>
> >> Then I have noticed the commit:
> >>
> >> commit f54a9d0e59c4bea3db733921ca9147612a6f292c
> >> Author: NeilBrown <neilb@suse.de>
> >> Date:   Thu Aug 2 08:33:20 2012 +1000
> >>
> >>     md/raid1: submit IO from originating thread instead of md thread.
> >>
> >> Looking at the code, I learned that to avoid switching into raid1d,
> >> the caller has to use blk_start_plug/blk_finish_plug. So I added these
> >> calls in our kernel module, which submits bios to MD. Results were
> >> awesome, MD latency got down significantly.
> >
> > That's good to hear.
> >
> >>
> >> So I have several questions about this plug/unplug thing.
> >>
> >> 1/ Originally this infrastructure was supposed to help IO schedulers
> >> in merging requests. It is useful when one has a bunch of requests to
> >> submit in one shot.
> >
> > That is exactly the whole point of plugging:  allow the device to handl=
e a
> > batch of requests together instead of one at a time.
> >
> >> But in MD case, thus infrastructure is used for a different purpose:
> >> not to merge requests (which may help bandwidth, but probably not
> >> latency), but to avoid making raid1d a bottleneck, to be able to
> >> submit requests from multiple threads in parallel, which brings down
> >> latency significantly in our case. Indeed "struct blk_plug" has a
> >> special "cb_list", which is used only by MD.
> >
> > I don't think the way md uses plugging is conceptually different from a=
ny
> > other use: it is always about gathering a batch together.
> > "cb_list" is handled by blk_check_plugged() which is also used by
> > block/umem.c and btrfs.
> >
> > The base plugging code assumes that it is only gathering a batch of req=
uests
> > for a single device - if the target device changes then the batch is fl=
ushed.
> > It also assumed that it was "struct request" that was batched.
> > Devices like md that want to queue 'struct bio', something else was nee=
ded.
> > Also with layered devices it can be useful to gather multiple batches f=
or
> > multiple layers.
> > So I created "cb_list" etc and a more generic interface.
> >
> >> In my case I have only individual bios (not a bunch of bios), and I
> >> after wrap them with plug/unplug, MD latency gets better. So we are
> >> using the plug infrastructure for a different purpose.
> >> Is my understanding correct? Was this your intention?
> >
> > I don't really understand what you are doing.  There is no point in usi=
ng
> > plugging for individual bios.  The  main point for raid1 writes is to g=
ather
> > a lot of writes together so that all multiple bitmap bits can be set al=
l at
> > once.
> > It should be possible to submit individual bios directly from make_requ=
est
> > without passing them to raid1d and without using plugging.
> Can you pls explain how it is possible?
> You have this code for WRITEs:
>         cb =3D blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
>         if (cb)
>             plug =3D container_of(cb, struct raid1_plug_cb, cb);
>         else
>             plug =3D NULL;
>         spin_lock_irqsave(&conf->device_lock, flags);
>         if (plug) {
>             bio_list_add(&plug->pending, mbio);
>             plug->pending_cnt++;
>         } else {
>             bio_list_add(&conf->pending_bio_list, mbio);
>             conf->pending_count++;
>         }
>         spin_unlock_irqrestore(&conf->device_lock, flags);
>=20
> If the thread blk_check_plugged returns NULL, then you always hand the
> WRITE to raid1d. So the only option to avoid handoff to raid1d is for
> the caller to plug. Otherwise, all WRITEs are handed off to raid1d and
> latency becomes terrible.
> So in my case, I use plug/unplug for individual bios only to avoid the
> handoff to raid1d.
> What am I missing in this analysis?

if blk_check_plugged succeeds then it has arranged for raid1_unplug to be
called a little later by that same process.
So there is nothing to stop you calling raid1_unplug immediately.

raid1_unplug essentially does:
  bitmap_unplug()
  generic_make_request()

so you can very nearly just do that, without any plugging.

There is a bit of extra subtlety but I can't really know how relevant that
might be to you without actually seeing you code.

NeilBrown

--Sig_/A8SfSBkFhpmJ/CPc9JQAFDA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA7MPDnsnt1WYoG5AQKezA/+MBKua3ImqHbn3SbxbjmUALksKdDyix+I
lo1B4TscTRwN383TPMcLI8crFuL7GpGKpAhiPcQyp/HvHGgRVc0sK8UE+4gvCxKx
L/Sn8yW+HZCQkRX2UewjbBum1wLi8cRl+qEJ9cwxGYZ/ys2UYDugrGdKWAyFvNX1
cCgPu89xliblb5ZgJcJz8DRapJQ6Xkyr+jbqCa4jftThRjMVTe4Ttr9vv5LHzYOH
UJhXojel8CMrNGVgsOdAenUexq7mwosOcF2LFpm9OWAwj2621fPD4u+b6a+/60/Y
xB7ORdwMNSOaDUa4qNiM8F36+nlY0S+ZywXaDpNFa9TfnYPi+tYOAdSWcuYKkSry
MQWoHwO295BecIsnMMVzd+DhJEMaIwp6uGOy6W1b3z8PspIT2INltKqdfgmaqsFk
i8I5He35Y5WvzUkdtGV89WXuBJI81EdPq5SQTNcl3kJ0vEj8RfAiuty/yRI7INw9
Q1H7CtGSjCe/Ww0mLSKpna7L+qKMumyH0dqag70YSa9JST+hEbyEeShk5bD06bWm
ZNooPyaT8SanWHvjfCKE2J8h+XjtDLcPygl8D02ghF+gCq3v/u5j+nX1+Zy9GR64
ZTE+5dgS/yyOyX6iNw9CIrN1AP1Vi3wDAsFgvEGJJwRtZmHL7jF3GdvNA83qAhr1
UARtYYJrX/0=
=mJtL
-----END PGP SIGNATURE-----

--Sig_/A8SfSBkFhpmJ/CPc9JQAFDA--
