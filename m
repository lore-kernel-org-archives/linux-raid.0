From: NeilBrown <neilb@suse.de>
Subject: Re: MD array keeps resyncing after rebooting
Date: Mon, 5 Aug 2013 16:08:28 +1000
Message-ID: <20130805160828.7c01c21c@notabene.brown>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
	<51EED0DA.3020901@arcor.de>
	<51EED102.4020503@arcor.de>
	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
	<51EEF3D3.7020305@arcor.de>
	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>
	<CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
	<51F1754B.5000905@arcor.de>
	<CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
	<51FAA5C3.8030109@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vrNRIEAf15KP2dCJqV+xEaQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FAA5C3.8030109@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vrNRIEAf15KP2dCJqV+xEaQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Aug 2013 20:15:31 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hello Francis,
> >=20
> > As you noticed the state is "Not Consistent". In my understanding it
> > becomes "Consistent" when  the array is stopped.
>=20
> Correct.
>=20
> > I checked during the shudown process that the array is correctly
> > stopped since at that point I got:
> >=20
> > # mdadm -E /dev/sda | egrep "state"
> >         state[0] : Optimal, Consistent
> >    init state[0] : Fully Initialised
>=20
> This looks as it should, actually. This looks as if md is doing what
> it's supposed to.
>=20
> > After rebooting, it appears that the BIOS changed a part of VD
> > GUID[0]. I'm not sure if that can confuse the kernel and if it's the
> > reason why the kernel shows:
> >=20
> >     [  832.944623] md/raid1:md126: not clean -- starting background
> > reconstruction
>=20
> The BIOS obviously changes the meta data. The GUID itself shouldn't be
> the problem as long as it's consistently changed everywhere, but it's
> certainly strange to change it - it's meant to be constant and unique
> for this array.
>=20
> It would be important to see the state of the meta data after md
> shutdown and immediately after boot (before md actually starts), so that
> we can exactly see what the BIOS has done.
>=20
> > but this is obviously where a resync is triggered during each reboot
> > whatever the initial state of the array. The kernel message is
> > actually issued by drivers/md/raid1.c, in particular:
> >=20
> >         if (mddev->recovery_cp !=3D MaxSector)
> >                 printk(KERN_NOTICE "md/raid1:%s: not clean"
> >                        " -- starting background reconstruction\n",
> >                        mdname(mddev));
> >=20
> > I don't understand the condition and how a resync can be triggered ther=
e.
>=20
> The kernel is just reacting to something it has been told by
> mdadm/mdmon. mdadm, in turn, just reads the meta data. It is highly
> likely that the meta data indicated that the array was not, or only
> partially, initialized. In this case mdadm will always start a full
> reconstruction.
>=20
> > Oh, this is with kernel 3.4.54.
> >=20
> > Can you (or anyone else) spot something wrong with these information ?
>=20
> Well, obviously the BIOS made a change to the meta data. Why so? We can
> only guess; perhaps something that mdadm wrote to the meta data didn't
> please the BIOS code, and it "thought" it needed to do something
> differently.
>=20
> mdadm -E may not be enough here. We need to inspect the raw meta data
> 1. after BIOS created the array and before mdadm started
> 2. after mdadm shutdown
> 3. after BIOS reboot, before mdadm started.
> 4. (if you have a windows driver, it might be interesting to see how the
> meta data looks after windows has shut down after step 1.)
>=20
> You can dump the metadata with mdadm --dump, but the result is difficult
> to handle because it's a sparse image the size of your disk.
> Unless all your tools handle sparse files well, you will get stuck.
>=20
> Here is a slightly more type-intensive but safer method:
>=20
> Use "sg_readcap /dev/sda" to print the LBA of the last block.
> Using this number, run
>=20
>  dd if=3D/dev/sda of=3D/tmp/sda bs=3D1b skip=3D$LBA
>=20
> then do hexdump -C /tmp/sda. You see your "DDF anchor" structure. At
> offsets 0x0060 and 0x0068, you find the LBAs of the primary and
> secondary header, in big endian. Use the smaller number of the two
> (usually the secondary header at 0x0068). In may case the hexdump line re=
ads
>=20
> 00000060  00 00 00 00 3a 37 c0 40  00 00 00 00 3a 37 20 50
>=20
> The primary LBA is 0x3a37c040, the secondary 3a372050, which is less.
> Next, using the smaller number, run
>=20
> dd if=3D/dev/sda bs=3D1b skip=3D$((0x3a372050)) | gzip -c /tmp/sda-ddf.gz
>=20

For future reference, with mdadm 3.3 you can
 mkdir /tmp/md
 mdadm --dump /tmp/md /dev/sd*
 tar czSvf /tmp/md.tgz /tmp/md

The files in /tmp/md are sparse (lots of zeros).=20
The 'S' flag to tar tells it to handle these well.
So

 tar xvf /tmp/md.tgz

will recover the sparse files which will have the metadata and nothing else.

NeilBrown

--Sig_/vrNRIEAf15KP2dCJqV+xEaQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUf9BXDnsnt1WYoG5AQKpQg//aYZSfXnWeDxcGzJ8aQHXxTs1s9Arn8zh
xwI0o7qaGmL1jJoRDG2+XARfElnCpbGOxN7Dob0z8gUZQqpDH97dOXbUu9BhXnD6
gdYcogKqSyh9RgPuwejDPwZubYnzj2LFX//kFaq3HRIa/z9Ylip5/nNTuLNM1sk5
Cgb0p59UghpiUbqx06PjNv24P2ale8N8sFt3dVHz05LGMfatSA+FPbccxgIo71RQ
4BKLAuPryBM6cUL4reIzvNjVyme6HSRv6hK9BUfTTSEArUu4nL6LQZDrTQaWB2qu
5TwsL/QvCTZQnELc7Jsi45GIDEyFTkVDdCCDJpQxAcAnkBx4+H/jt84TZ8l8Wdy5
DmutuGH/qK5iFtHg2rnSDYB2v4LRP9G+xelRfE9/J9wTyFeguOVyMZ99yz0Y/FxT
6SoqJDqAIv/lxy7WGTbfOQpbEiTTfCx832ELmy0LyOIKW2L0q+iNIspSzSkj12fc
k7Iv7u5CJj3qYbHlwoMxq/z6jXjNxioLSHF3El+J7TvJhiMhOQVYqIYHiQygvSnA
BeGFfT5TLamzvINXrDXk+bx7sTjVMUyG0IdAbOhqzAgCETe6w66weImhfiCaGJyT
fdCJnWXDJ4J4soukTmx8dvml1Y4AdC+PiBEO9E0C9svYNew8lGmKDvmfG8O+Lmfo
YE8u3wpiLlU=
=s1+s
-----END PGP SIGNATURE-----

--Sig_/vrNRIEAf15KP2dCJqV+xEaQ--
