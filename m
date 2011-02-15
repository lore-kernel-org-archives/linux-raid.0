From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: mdadm: recovering from an aborted reshape op - boot messages
Date: Mon, 14 Feb 2011 18:04:01 -0800 (PST)
Message-ID: <729509.31129.qm@web65105.mail.ac2.yahoo.com>
References: <20110215124107.7b6edea3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215124107.7b6edea3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hiel,

Comments interspersed.

--- On Tue, 15/2/11, NeilBrown <neilb@suse.de> wrote:

> From: NeilBrown <neilb@suse.de>
> Subject: Re: mdadm: recovering from an aborted reshape op - boot mess=
ages
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Date: Tuesday, 15 February, 2011, 14:41
> On Mon, 14 Feb 2011 17:11:49 -0800
> (PST) Gavin Flower <gavinflower@yahoo.com>
> wrote:
>=20
> > Hi Neil,
> >=20
> > Comments interspersed..
> >=20
> > --- On Tue, 15/2/11, NeilBrown <neilb@suse.de>
> wrote:
> >=20
> > > From: NeilBrown <neilb@suse.de>
> > > Subject: Re: mdadm: recovering from an aborted
> reshape op - boot messages
> > > To: "Gavin Flower" <gavinflower@yahoo.com>
> > > Cc: linux-raid@vger.kernel.org
> > > Date: Tuesday, 15 February, 2011, 12:55
> > > On Mon, 14 Feb 2011 14:47:48 -0800
> > > (PST) Gavin Flower <gavinflower@yahoo.com>
> > > wrote:
> > >=20
> > > > Hi Neil,
> > > >=20
> > > > I did not notice this before (note: I have
> poor
> > > eyesight, so unless I explicitly look, I may not
> notice
> > > things!). but just before Fedora drops to the
> shell on a
> > > reboot I saw these messages (hand transcribed, so
> might have
> > > the odd transcription error):
> > > >=20
> > > > /dev/md1: The filing system size (according
> to the
> > > superblock) is 76799952 blocks
> > > > The physical size of the device is 76799616
> > > > Either the superblock or the partition table
> is likely
> > > to be corrupt!
> > > >=20
> > > > /dev/md1: UNEXPECTED INCONSISTENCY: RUN fsck
> manually
> > > > (i.e. without -a or -p options)
> > > >=20
> > > > Note that original size according mdadm was
> not a
> > > multiple of 512KB, so I reshaped it to be the
> largest
> > > multiple or 512KB less than the original
> size.=C2=A0 So my
> > > second attempt to reshape, using the 512 chunk
> size, started
> > > okay.
> > > >=20
> > > > Advice appreciated.
> > >=20
> > > Hmmm....
> > >=20
> > > Firstly, the -A and -E output you sent are
> inconsistent.
> >=20
> > I can not explain the inconsistency.
> >=20
> > However, they were both done on the same machine
> ('saturn').
> >=20
> > No software updates were done on 'saturn' since before
> the reshaping.
> >=20
> > The -A output was the process that took over an hour.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
> =C2=A0 =C2=A0=C2=A0=C2=A0^^^^^^^^^^^^^^^^^^^
>=20
> That is the piece of information that I was missing.
> The array was assembled, reshape continued. Reshape
> completed.
> Then you looked at the -E output after that.
>=20
> So it all makes sense.=C2=A0 The reshape has completed.
>=20
>=20
> > > Secondly, as you say you reshaped the array to
> make it
> > > slightly smaller so it
> > > would be a multiple of 512K.=C2=A0 This is
> obviously needed
> > > to change the chunk
> > > size.
> >=20
> > I used the =E2=80=93size=3D
> >=C2=A0 option of mdadm
> > >=20
> > > But before you did that - did you resize the
> filesystem to
> > > be only that big?
> >=20
> > No, and there is no mention in man mdadm to do so,
> that I could see.
> >=20
> > > I suspect not.=C2=A0 So the filesystem thinks
> that it is
> > > bigger than the device.
> > > I don't know how best to fix that.
> >=20
> > I would have thought mdadm would have done that as
> part of the process =E2=80=93 as surely the size of the filesystem
> could not be reduced in advance of the reshaping.
> >=20

One obvious thing that I had overlooked, is that the RAID array _CONTAI=
NS_ the filing system and _NOT_ vice versa- something I knew, but didn'=
t recall when I wrote the above!

> > Perhaps, I have overlooked the obvious?
>=20
> mdadm isn't not able to make the filesystem smaller, nor is
> it able to tell
> if the filesystem is small enough that it won't be a
> problem.
>=20
> I thought it was "obvious" that you would shrink the
> filesystem before
> shrinking the device that contains it, but clearly it is
> not. I have updated
> the man page - see patch below.
>=20
> It would be really nice of the kernel could have some sort
> of inter-lock so
> the device could ask the filesystem is shrinkage is OK, but
> we don't have
> that currently.
>=20
> NeilBrown
>=20
>=20
>=20
> commit c26d78fe040673b019e1c2e4a5507969d2869765
> Author: NeilBrown <neilb@suse.de>
> Date:=C2=A0=C2=A0=C2=A0Tue Feb 15 12:40:21 2011 +1100
>=20
> =C2=A0 =C2=A0 mdadm.man add encouragement to shrink
> filesystem before shrinking array.
> =C2=A0 =C2=A0=20
> =C2=A0 =C2=A0 Before resizing an array with --size or
> --array-size, then filesystem
> =C2=A0 =C2=A0 should be resized.=C2=A0 mdadm cannot do this
> so the user should.
> =C2=A0 =C2=A0=20
> =C2=A0 =C2=A0 Reported-by: Gavin Flower <gavinflower@yahoo.com>
> =C2=A0 =C2=A0 Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index fafb305..b2e6c05 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -427,12 +427,24 @@ The size can be given as
>  .B max
>  which means to choose the largest size that fits on all
> current drives.
> =20
> +Before reducing the size of the array (with
> +.BR "\-\-grow \-\-size=3D" )
> +you should make sure that space isn't needed.=C2=A0 If the
> device holds a
> +filesystem, you would need to resize the filesystem to use
> less space.
> +
> +After reducing the array size you should check that the
> data stored in
> +the device is still available.=C2=A0 If the device holds a
> filesystem, then
> +an 'fsck' of the filesystem is a minimum
> requirement.=C2=A0 If there are
> +problems the array can be made bigger again with no loss
> with another
> +.B "\-\-grow \-\-size=3D"
> +command.
> +
>  This value can not be used with
>  .B CONTAINER
>  metadata such as DDF and IMSM.
> =20
>  .TP
> -.BR \-Z ", " \-\-array-size=3D
> +.BR \-Z ", " \-\-array\-size=3D
>  This is only meaningful with
>  .B \-\-grow
>  and its effect is not persistent: when the array is
> stopped and
> @@ -446,6 +458,17 @@ but setting the size with
>  is, it is required that the array size is reduced as
> appropriate
>  before the number of devices in the array is reduced.
> =20
> +Before reducing the size of the array you should make sure
> that space
> +isn't needed.=C2=A0 If the device holds a filesystem, you
> would need to
> +resize the filesystem to use less space.
> +
> +After reducing the array size you should check that the
> data stored in
> +the device is still available.=C2=A0 If the device holds a
> filesystem, then
> +an 'fsck' of the filesystem is a minimum
> requirement.=C2=A0 If there are
> +problems the array can be made bigger again with no loss
> with another
> +.B "\-\-grow \-\-array\-size=3D"
> +command.
> +
>  A suffix of 'M' or 'G' can be given to indicate Megabytes
> or
>  Gigabytes respectively.
>  A value of
>=20
>=20

<Chuckle> I never expected to have my name on a commit to Linux!

output from: fsck.ext4 -f -n /dev/md1

e2fsck 1.41.12 (17-May-2010)
The filesystem size (according to the superblock) is 76799952 blocks
The physical size of the device is 76799616 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort? no

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -9626 -(9728--9752) +(405344--405369)
=46ix? no


I suspect that it might be simple to recover.  Are you able to advise o=
n this, or should I run further diagnostics, or ask elsewhere.


Thanks,
Gavin

/dev/md1: ********** WARNING: Filesystem still has errors **********

/dev/md1: 1693644/19202048 files (0.3% non-contiguous), 54273929/767999=
52 blocks


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
