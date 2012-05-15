From: NeilBrown <neilb@suse.de>
Subject: Re: Hot-replace for RAID5
Date: Tue, 15 May 2012 20:43:22 +1000
Message-ID: <20120515204322.4ee77ea4@notabene.brown>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
	<CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
	<CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
	<20120513091901.5265507f@notabene.brown>
	<CAAOsTSk7dDcMGGJgAJ6GSDU2WpsJPTS3Vb80WKy6CObwtemfgQ@mail.gmail.com>
	<CAAOsTSkVwCkY3YAKPTDFo2uZoG6S6Et0DYtDzk+QNfy+N3kMag@mail.gmail.com>
	<20120514081523.2f38dbb8@notabene.brown>
	<CAAOsTSm3aQFydumTfAVr2DQZoxcENvzpfyS8zbNdxUcnFsDkpQ@mail.gmail.com>
	<CAAOsTSkTXy0zP0OBBOPg7+=nc0Acshz2jrsB8fTF55VNeUEHxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SGvCHmASWKnp.R4n99Kz6y1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSkTXy0zP0OBBOPg7+=nc0Acshz2jrsB8fTF55VNeUEHxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SGvCHmASWKnp.R4n99Kz6y1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 12:11:28 +0200 Patrik Horn=EDk <patrik@dsl.sk> wrote:

> Neil,
>=20
> did you have a chance to look at how to migrate from raid5 to raid6
> without reshaping and/or why layout=3Dpreserve did not work?

Yes.
http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D385167f364122c9424a=
a3d56f00b8c0874ce78b8

fixes it.
--layout=3Dpreserve works properly after that patch.

>=20
> Regarding failing drive during reshape I was worried, because I found
> some mentions of problems in mailing lists from 1-2 years ago, like
> non-functional backup-file after failing drive or worse... But I
> tested it on test array and it worked, so I did it.

testing =3D=3D good !!

>=20
> Now I am getting constant speed 2.3 MB/s. Is it not too slow? It is
> not CPU constrained, it is I/O. But nothing else is going on the
> drives, they are all modern drives, backup is now on different drive,
> so if it is enough sequential it should be much higher. What should be
> the pattern of I/O operations it uses? It is 7 x HDD RAID5 to RAID6
> migration, chunk size is 64K, backup file is about 50M.

Yes, it is painfully slow.
It reads from the array and writes to the backup.  Then allows reshape to
progress which might read from the array again, and writes to the array.
It is doing this in 50M blocks

How big is the stripe cache - /sys/block/md0/md/stripe_cache_size ??
To hold 50M it needs 50M/4K/6 =3D=3D 2133 entries.
And it might need to hold it twice - once for the old layout and once for t=
he
new.
So try increasing it to about 5000 if it isn't there already.
That might reduce the reads and allow it to flow more smoothly.

NeilBrown


>=20
> Thanks.
>=20
> Patrik
>=20
> On Mon, May 14, 2012 at 2:52 AM, Patrik Horn=EDk <patrik@dsl.sk> wrote:
> > Well,
> >
> > I used raid=3Dnoautodetect and the other arrays did start automatically.
> > I am not sure who started them, maybe =A0initscripts... But the one
> > which is reshaping thankfully did not start.
> >
> > Unfortunately =A0the speed is not much better. The top speed is up by
> > cca third to maybe 2.3 MB/s, which seems pretty small and I am unable
> > to quickly pinpoint the exact reason.Do you have idea what can it be
> > and how to improve speed?
> >
> > In addition the performance problem with bad drive periodically kicks
> > in sooner and thus the average speed is almost the same, around 0.8 to
> > 0.9 MB/s. I am thinking about failing the problematic drive. Except
> > that I will end up without redundancy for yet not reshaped part,
> > should the failing work as expected even in the situation array is
> > now? (raid6 with 8 drives, 7 active devices in not yet reshaped part,
> > couple of times stopped and start with backup-file.)
> >
> > Thanks.
> >
> > Patrik
> >
> > On Mon, May 14, 2012 at 12:15 AM, NeilBrown <neilb@suse.de> wrote:
> >> On Sun, 13 May 2012 23:41:35 +0200 Patrik Horn=EDk <patrik@dsl.sk> wro=
te:
> >>
> >>> Hi Neil,
> >>>
> >>> I decided to move backup file on other device. I stopped the array,
> >>> mdadm stopped it but wrote "mdadm: failed to unfreeze array". What
> >>> does it exactly mean? I dont want to proceed until I am sure it does
> >>> not signalize error.
> >>
> >> That would appear to be a minor bug in mdadm - I've made a note.
> >>
> >> When reshaping an array like this, the 'mdadm' which started the resha=
pe
> >> forks and continues in the background managing the the =A0backup file.
> >> When it exits, having completed, it makes sure that the array is 'unfr=
ozen'
> >> just to be safe.
> >> However if it exits because =A0the array was stopped, there is no arra=
y to
> >> unfreeze an it gets a little confused.
> >> So it is a bug but it does not affect the data on the devices or indic=
ate
> >> that anything serious went wrong when stopping the array.
> >>
> >>>
> >>> I quickly checked sources and it seems to be related to some sysfs
> >>> resources, but I am not sure. But the array disappeared from
> >>> /sys/block/.
> >>
> >> Exactly. =A0And as the array disappeared, it really has stopped.
> >>
> >>
> >>>
> >>> Thanks.
> >>>
> >>> Patrik
> >>>
> >>> On Sun, May 13, 2012 at 9:43 AM, Patrik Horn=EDk <patrik@dsl.sk> wrot=
e:
> >>> > Hi Neil,
> >>> >
> >>> > On Sun, May 13, 2012 at 1:19 AM, NeilBrown <neilb@suse.de> wrote:
> >>> >> On Sat, 12 May 2012 17:56:04 +0200 Patrik Horn=EDk <patrik@dsl.sk>=
 wrote:
> >>> >>
> >>> >>> Neil,
> >>> >>
> >>> >> Hi Patrik,
> >>> >> =A0sorry about the "--layout=3Dpreserve" confusion. =A0I was a bit=
 hasty.
> >>> >> =A0-layout=3Dleft-symmetric-6" would probably have done what was w=
anted, but it
> >>> >> =A0is a bit later for that :-(
> >>> >
> >>> > --layout=3Dpreserve is mentioned also in the md or mdadm
> >>> > documentation... So is it not the right one?
> >>
> >> It should be ... I think. =A0But it definitely seems not to work. =A0I=
 only have
> >> a vague memory of how it was meant to work so I'll have to review the =
code
> >> and add some proper self-tests.
> >>
> >>> >
> >>> >>>
> >>> >>> so I further analyzed the behaviour and I found following:
> >>> >>>
> >>> >>> - The bottleneck cca 1.7 MB/s is probably caused by backup file o=
n one
> >>> >>> of the drives, that drive is utilized almost 80% according to ios=
tat
> >>> >>> -x and its avg queue length is almost 4 while having await under =
50
> >>> >>> ms.
> >>> >>>
> >>> >>> - The variable speed and low speeds down to 100 KB are caused by
> >>> >>> problems on drive I suspected as problematic. Its service time is
> >>> >>> sometimes going above 1 sec.. Total avg speed is about 0.8 MB/s. =
(I
> >>> >>> tested the read speed on it by running check of array and it work=
ed
> >>> >>> with 30 MB/s. And because preserve should only read from it I did=
 not
> >>> >>> specifically test its write speed )
> >>> >>>
> >>> >>> So my questions are:
> >>> >>>
> >>> >>> - Is there a way I can move backup_file to other drive 100% safel=
y? To
> >>> >>> add another non-network drive I need to restart the server. I can=
 boot
> >>> >>> it then to some live distribution for example to 100% prevent
> >>> >>> automatic assembly. I think speed should be couple of times highe=
r.
> >>> >>
> >>> >> Yes.
> >>> >> If you stop the array, then copy the backup file, then re-assemble=
 the
> >>> >> array giving it the backup file in the new location, all should be=
 well.
> >>> >> A reboot while the array is stopped is not a problem.
> >>> >
> >>> > Should or will? :) I have 0.90, now 0.91, metadata, is everything
> >>> > needed stored there? Should mdadm 3.2.2-1~bpo60+2 from
> >>> > squeeze-backports work well? Or should I compile mdadm 3.2.4?
> >>
> >> "Will" requires clairvoyance :-)
> >> 0.91 is the same as 0.90, except that the array is in the middle of a =
reshape.
> >> This make sure that old kernels which don't know about reshape never t=
ry to
> >> start the array.
> >> Yes - everything you need is stored in the 0.91 metadata and the backu=
p file.
> >> After a clean shutdown, you could manage without the backup file if yo=
u had
> >> to, but as you have it, that isn't an issue.
> >>
> >>> >
> >>> > In case there is some risk involved I will need to choose between
> >>> > waiting and risking power outage happening sometimes in the followi=
ng
> >>> > week (we have something like storm season here) and risking this...
> >>
> >> There is always risk.
> >> I think you made a wise choice in choosing the move the backup file.
> >>
> >>> >
> >>> > Do you recommend some live linux distro installable on USB which is
> >>> > good for this? (One that has newest versions and dont try assemble
> >>> > arrays.)
> >>
> >> No. =A0Best to use whatever you are familiar with.
> >>
> >>
> >>> >
> >>> > Or will automatic assemble fail and it will cause no problem at all
> >>> > for sure? (According to md or mdadm doc this should be the case.) In
> >>> > that case can I use distribution on the server, Debian stable plus
> >>> > some packages from squeeze, for that? Possibly with added
> >>> > raid=3Dnoautodetect? I have LVM on top of raid arrays and I dont wa=
nt to
> >>> > cause mess. OS is not on LVM or raid.
> >>> >
> >>
> >> raid=3Dnoautodetect is certainly a good idea. I'm not sure if the in-k=
ernel
> >> autodetect will try to start a reshaping raid - I hope not.
> >>
> >>> >>>
> >>> >>> - Is it safe to fail and remove problematic drive? The array will=
 be
> >>> >>> down to 6 from 8 drives in part where it is not reshaped. It shou=
ld
> >>> >>> double the speed.
> >>> >>
> >>> >> As safe as it ever is to fail a device in a non-degraded array.
> >>> >> i.e. it would not cause a problem directly but of course if you ge=
t an error
> >>> >> on another device, that would be awkward.
> >>> >
> >>> > I actually "check"-ed this raid array couple of times few days ago =
and
> >>> > data on other drives were OK. Problematic drive reported couple of
> >>> > reading errors, always corrected with data from other drives and by
> >>> > rewriting.
> >>
> >> That is good!
> >>
> >>> >
> >>> > About that, shoud this reshaping work OK if it encounter possible
> >>> > reading errors on problematic drive? Will it use data from other
> >>> > drives to correct that also in this reshaping mode?
> >>
> >> As long as there are enough working drives to be able to read and writ=
e the
> >> data, the reshape will continue.
> >>
> >> NeilBrown
> >>
> >>
> >>> >
> >>> > Thanks.
> >>> >
> >>> > Patrik
> >>> >
> >>> >>>
> >>> >>> - Why mdadm did ignore layout=3Dpreserve? I have other arrays in =
that
> >>> >>> server in which I need replace the drive.
> >>> >>
> >>> >> I'm not 100% sure - what version of mdadm are you using?
> >>> >> If it is 3.2.4, then maybe commit 0073a6e189c41c broke something.
> >>> >> I'll add test for this to the test suit to make sure it doesn't br=
eak again.
> >>> >> But you are using 3.2.2 .... Not sure. I'd have to look more close=
ly.
> >>> >>
> >>> >> Using --layout=3Dleft-symmetric-6 should work, though testing on s=
ome
> >>> >> /dev/loop devices first is always a good idea.
> >>> >>
> >>> >> NeilBrown
> >>> >>
> >>> >>
> >>


--Sig_/SGvCHmASWKnp.R4n99Kz6y1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7IzSjnsnt1WYoG5AQInJg//VX6u2IczOC+i616pBXdLV/zZ/onchbt9
3KP9o60ps6n+dGtKs/lbWspsiT4B4oWA41ABafTvxaAJazeZrLihQYfs6gNQFsMf
Duwhm1a03Vx4ybD161zCcKZw3c/TuEMg+Hr3AVKFYVv1YHjMNeBtyvKeGPr+s1fm
t1EBsn+SCGQ78NWP+S0Fl/6pMyZihNgfP8zuKu0S24ne8eCWrmE58nSlUbyeLkAV
ED4WEuJtRc8DIrJGI4HDz4rg9YjQj8VyUQzkGX1mx5YpWPdzDhn1xc2Yn1OdurIT
RRXouyLO0Iq5jKGqptYmeJaEwQyKIodBEGKhkHKVPlvqyBtngX8A7uH19/xd01uW
DdoII009odq+X3EiPA9N2Ch/SafgjbhYimikS9fWujUifAexvXfMho2xuG4bPIzV
dUFp+cbuEu8VHQZaDc6OVd/WElejxyQFMMt8fPbSHh8ita/aj31pVLHvCq+yPUBZ
O0AnLA28BLvbaTSm180nfMzFrqq2ASlDLC1p0KlLja+RCUShGJDSt05R/VA4FClu
jZeOo1avs2bxSgY9tKYIsbfH00NPn8qBpca8OfD7TeUciPUsEVohPRU2Vy8IwojI
gUwCsT9uEMMnATan4jH1y8rRQugQOTWfM1Uz9go3WERQsfXkjDv/pFXtAzRIkLHB
PRfprysaLlI=
=piRB
-----END PGP SIGNATURE-----

--Sig_/SGvCHmASWKnp.R4n99Kz6y1--
