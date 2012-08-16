From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Thu, 16 Aug 2012 17:28:13 -0600
Message-ID: <201208161728.13814.thomas@fjellstrom.ca>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com> <CAH-e9vJkrv2R-HTR7JfHwZK1sbYQ3fduGbtxEwtor4gtyd6PKQ@mail.gmail.com> <20120507105458.6411b0cf@notabene.brown>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120507105458.6411b0cf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun May 6, 2012, NeilBrown wrote:
> On Mon, 7 May 2012 00:32:35 +0000 Gar=F0ar Arnarsson <gardar@giraffi.=
net>=20
wrote:
>=20
> > That's an excellent idea, I was going to add another disk for extra=
 space
> > right after migrating to raid6.
> >=20
> > Just to be clear, I'll be running the normalize attribute just once=
 to
> > straighten the array out right? Or will I have to do it for every e=
xtra
> > drive I add in the future?
>=20
> Just once.
>=20
> >=20
> > And what are the N+1 you mention in --raid-devices=3DN+1
>=20
> By "N+1" I just meant "1 more than the number of devices currently in=
 the
> array".
>=20
> If you have both new devices ready to go, you just do a single reshap=
e
> operation that converts to RAID6 and adds more space.  This does not =
need a
> backup file and is probably the best approach.
>=20
> If you currently have a 10-drive RAID5 and want a 12-drive RAID6, the=
n
>=20
>  mdadm --grow /dev/md0 --raid-devices=3D12 --level=3D6
>=20
> is what you want.

I apologize for bringing back a long dead thread, but I've been wonderi=
ng if=20
mdadm does the grow op in this case, in one step? Or does it internally=
 do=20
each step separately, doing a reshape with each one?

I've currently got a 7x1TB disk raid5, and have a couple more disks to =
add and=20
I was planning on moving to raid6. I'm hoping to reduce the amount of t=
ime the=20
array is "reshaping" because I'm a bit paranoid that my bad luck with h=
ard=20
drives will decide to hit right then and there.

> NeilBrown
>=20
>=20
> >=20
> > Thanks.
> >=20
> >=20
> > 2012/5/6 NeilBrown <neilb@suse.de>
> >=20
> > > On Sun, 6 May 2012 10:17:52 +0000 Gar=F0ar Arnarsson <gardar@gira=
ffi.net>
> > > wrote:
> > >
> > > > My raid5 array has gotten a bit big, it's containing total 10 d=
rives
> > > > right now (I started out with 3 drives). So I am going to conve=
rt it
> > > > to raid6 before it gets any bigger.
> > > >
> > > > I am doing a test-run on a virtual machine with virtual drives =
to see
> > > > that everything works flawlessly.
> > > >
> > > > When I tried to convert the array to raid6 I got a error messag=
e about
> > > > a missing backup-file
> > > >
> > > > mdadm --grow /dev/md0 --raid-devices=3D5 --level=3D6
> > > >
> > > > mdadm level of /dev/md0 changed to raid6
> > > > mdadm: /dev/md0: Cannot grow - need backup-file
> > > > mdadm: aborting level change
> > > >
> > > > I added the backup file and was able to convert the array succe=
ssfully
> > > > after that.
> > > >
> > > > My question is, how big is this backup file going to be? My rea=
l raid
> > > > array consists of 2tb drives, will the backup file be as big as=
 one
> > > > drive in the array, or will it just be few megabytes or gigabyt=
es?
> > > > I'm asking because I'm wondering if I need to buy an extra hdd =
for the
> > > > backup file or if the backup file can just be on my OS hdd that=
 has
> > > > around 100gb free.
> > >
> > > The backup file is a few megabytes. Around 16MB I think.
> > >
> > > However if you are likely to add another device in the not too di=
stant
> > > future
> > > you can save yourself a bit of time.
> > >
> > > If you
> > >
> > >  mdadm --grow /dev/md0 --level=3D6 --layout=3Dpreserve
> > >
> > > It will just make the new few a 'Q-block' device, containing the =
extra
> > > RAID6
> > > 'parity' block for each stripe.  This doesn't require any reshape=
 or or=20
any
> > > backup file and is a lot faster.  All it requires is a normal rec=
overy
> > > operation.
> > >
> > > Then when you later add another device you can
> > >
> > >  mdadm --grow /dev/md0 --raid-devices=3DN+1 --layout=3Dnormalise
> > >
> > > This will convert from the Q-on-the-last-device layout to a more =
normal
> > > rotated-P-and-Q layout at the same time as adding extra space.
> > >
> > > NeilBrown
> > >
> >=20
> >=20
> >=20
>=20
>=20


--=20
Thomas Fjellstrom
thomas@fjellstrom.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
