From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: mdadm: recovering from an aborted reshape op - boot messages
Date: Mon, 14 Feb 2011 17:11:49 -0800 (PST)
Message-ID: <434600.40091.qm@web65106.mail.ac2.yahoo.com>
References: <20110215105508.137097fa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110215105508.137097fa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Comments interspersed..

--- On Tue, 15/2/11, NeilBrown <neilb@suse.de> wrote:

> From: NeilBrown <neilb@suse.de>
> Subject: Re: mdadm: recovering from an aborted reshape op - boot mess=
ages
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Date: Tuesday, 15 February, 2011, 12:55
> On Mon, 14 Feb 2011 14:47:48 -0800
> (PST) Gavin Flower <gavinflower@yahoo.com>
> wrote:
>=20
> > Hi Neil,
> >=20
> > I did not notice this before (note: I have poor
> eyesight, so unless I explicitly look, I may not notice
> things!). but just before Fedora drops to the shell on a
> reboot I saw these messages (hand transcribed, so might have
> the odd transcription error):
> >=20
> > /dev/md1: The filing system size (according to the
> superblock) is 76799952 blocks
> > The physical size of the device is 76799616
> > Either the superblock or the partition table is likely
> to be corrupt!
> >=20
> > /dev/md1: UNEXPECTED INCONSISTENCY: RUN fsck manually
> > (i.e. without -a or -p options)
> >=20
> > Note that original size according mdadm was not a
> multiple of 512KB, so I reshaped it to be the largest
> multiple or 512KB less than the original size.  So my
> second attempt to reshape, using the 512 chunk size, started
> okay.
> >=20
> > Advice appreciated.
>=20
> Hmmm....
>=20
> Firstly, the -A and -E output you sent are inconsistent.

I can not explain the inconsistency.

However, they were both done on the same machine ('saturn').

No software updates were done on 'saturn' since before the reshaping.

The -A output was the process that took over an hour.

> The "-A" output reports:
>=20
> mdadm:/dev/md1 has an active reshape - checking if critical
> section needs to be restored
>=20
> For 0.90 metadata (which you are using), that can only be
> reported if the
> minor number is at least 91.  i.e. it has been
> temporarily set to 0.91.
>=20
> However the "-E" output show that all devices are
> "0.90.00", not 0.91.

I grepped strings /sbin/mdadm for '.9', and found both '0.90' and '0.91=
' - for what it is worth.

ls on /sbin/mdadm gives the size of 362296 bytes and the date 5 Aug 201=
0.
version is v3.1.2 - 10th March 2010

>=20
> So those devices cannot possibly produce that -A output.

The output was sent directly to the USB stick, so there are no transcri=
ption errors.  So as far as I can tell, these devices did produce the o=
utput. They are the only devices I have accessed using RAID many months=
=2E  There are only the 5 hard disks on 'saturn'.

Is there anything I can do to track down this anomaly?

>=20
> The devices appear to have all completely transitioned to
> 512K chunksize....
>=20
> And the -D output seems to show that the array is fine and
> working properly.
>=20
> Secondly, as you say you reshaped the array to make it
> slightly smaller so it
> would be a multiple of 512K.  This is obviously needed
> to change the chunk
> size.

I used the =E2=80=93size=3D
 option of mdadm
>=20
> But before you did that - did you resize the filesystem to
> be only that big?

No, and there is no mention in man mdadm to do so, that I could see.

> I suspect not.  So the filesystem thinks that it is
> bigger than the device.
> I don't know how best to fix that.

I would have thought mdadm would have done that as part of the process =
=E2=80=93 as surely the size of the filesystem could not be reduced in =
advance of the reshaping.

Perhaps, I have overlooked the obvious?

>=20
> You could try running 'resize2fs" now (was it ext3? I don't
> remember).  Or
> maybe an 'fsck -f' might fix it.
>=20
> It might be safest to ask on ext3-users@redhat.com.=20
> Report that you shrunk
> your array before shrinking the filesystem and ask what the
> best remedial
> strategy is.
>=20
> NeilBrown
>=20
>=20

I will look into your other suggestions about recovery.

If there is anything further I can do, to provide useful diagnostics, p=
lease let me now.


Thanks,
Gavin


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
