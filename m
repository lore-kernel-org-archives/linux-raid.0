From: NeilBrown <neilb@suse.de>
Subject: Re: Split-Brain Protection for MD arrays
Date: Thu, 15 Dec 2011 14:02:52 +1100
Message-ID: <20111215140252.2f9bb986@notabene.brown>
References: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/83W6XAzvraP.h=2ebo7.dby"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/83W6XAzvraP.h=2ebo7.dby
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 20:51:23 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil and all the MD developers.
>=20
> There've been a couple of emails asking about MD split-brain
> situations (well, one from a co-worker, so that doesn't count
> perhaps). A simplest example of a split-brain is a 2-drive RAID1
> operating in degraded mode, but after reboot array is re-assembled
> with the drive that previously failed.
>=20
> I would like to propose an approach that would detect when assembling
> an array may result in split-brain, and at least warn the user. The
> proposed approach is documented in a 3-page googledoc, linked here:
> https://docs.google.com/document/d/1sgO7NgvIFBDccoI3oXp9FNzB6RA5yMwqVN3_-=
LMSDNE/edit
> (anybody can comment).

I much prefer text to be inline in the email.  It is much easier to comment
on.  I really don't even want to think about learning how to comment on a
google-docs thing.


>=20
> The approach is very much based on what MD already has today in the
> kernel, with only one possible change. On the mdadm side, only code
> that checks things and warns the user needs to be added, i.e., no
> extra IOs or non-in-memory operations.

This "warns the user" thing concerns me somewhat.

The simplest examine of a possible split brain is a 2-device RAID1 where on=
ly
one device is available.   Your document seems to suggest that assembling
such an array should require user-intervention.  I cannot agree with that.
Even  assembling a 2-out-of-4 RAID6 should "just work".

We already have the "--no-degraded" option so that if someone wants to
request failure rather than possible-split brain.  I don't think we want or
need more than that.

>=20
> I would very much appreciate a review of the doc, mostly in terms of
> my understanding how MD superblocks work. The doc contains some lines
> in bold blue font, which are my questions, and comments are very
> welcome. I am in the process of testing the code changes I made in my
> system, once I am happy with them, I can post them as well for review,
> if there is interest. If the community decides that this has value, I
> will be happy to work out the best way to add the required
> functionality.
>=20
> I also have some additional questions, that popped why I was studying
> the MD code; any help on these is appreciated.
>=20
> - When a drive fails, the kernel skips updating its superblock, and
> updates all other superblocks that this drive is Faulty. How can it
> happen that a drive can mark itself as Faulty in its own superblock? I
> saw code in mdadm checking for this.

It cannot, as you say.

I don't remember why mdadm checks for that.  Maybe a very old version of the
kernel code could do that.


>=20
> - Why mdadm initializes the dev_roles[] array to 0xFFFF, but kernel
> initializes it to 0xFFFE? Since 0xFFFF also indicates a spare, this is
> confusing, we might think that we have 380+ spares...

"this is confusing" is exactly correct.
I never really sorted out what values I wanted in the dev_roles array.

With the benefit of the extra hindsight I now have, I think there should ha=
ve
been 3 special values:  'failed', 'spare' and 'missing'.

So we initialised to 'missing'.  As we add devices their slot first becomes
'spare', and then maybe becomes N (for some role in the array), and the
eventually 'failed' when the device fails (though this is never recorded on
the device itself).

If we re-add a failed device, we give it the same slot and make it 'spare' =
or
'N' again.

Eventually we could 'use up' all the available slots (no 'missing' slots
left) and so would need to convert some 'failed' slots to 'missing'.

So I guess when I was writing mdadm I thought that missing devices were
'spare' and when I was writing the kernel code I thought that 'missing'
devices were failed. :-(

We cannot safely add another special value now so I think the best way
forward is to treat 'spare' and 'missing' as the same.  So when we add a
spare we cannot just look for a free slot in the array, but must look at all
current spares as well to see what role they hold.  Awkward but not
impractical.

When we mark a device 'failed' it should stay marked as 'failed'.  When the
array is optimal again it is safe to convert all 'failed' slots to
'spare/missing' but not before.


>=20
> - Why event margin of 1 is permitted both in user and kernel? Is this
> for the case when we update all the superblocks in parallel in the
> kernel, but crash in the middle?

Exactly.

>=20
> - Why enough() function in mdadm ignores the "clean" parameter for
> raid1/10? Is this because if such array is unclean, then there is no
> way of knowing, even with all drives present, which copy contains the
> correct data?

In RAID1/RAID10, if the array is not clean we simply choose the 'first'
working devices (in some arbitrary ordering) and we have good-enough data.

In RAID5/6 if the array is not clean, then we cannot trust the parity so if
any device is missing, then the data for that device cannot be reliably
recovered.

They really a very different situations.



>=20
> - In Assemble.c: update_super(st, &devices[j].i, "assemble") is called
> and updates the "chosen_drive" superblock only (which might not even
> write this to disk, unless force is given), but later in add_disk the
> disk.state might still have the FAULTY flag set
> (because it was only cleared in the "chosen_drive" superblock). What
> am I missing?

The 'chosen' drive is the first one given to the kernel, and the kernel
believes it in preference to subsequent devices.  So rather  than update all
superblocks we only need to update one.


>=20
> - In Assemble.c: req_cnt =3D content->array.working_disks: taken from
> the "most recent" superblock, but even the most recent superblock may
> indicate a FAILED array.
> This actually leads to the question that interests me most, and I also
> ask it in the doc. Why do we continue updating the superblocks after
> the array fails? This way we basically loose "last known good
> configuration", i.e., we don't know the last good set of devices array
> was operating on. Had we known that, that might be useful in assisting
> people on recovering their arrays, I think. Otherwise, we need to
> guess in what sequence drives failed until the array died.

I've wondered that too - but never been quite confident enough to change it.

If you have a working array and you initiate a write of a data block and the
parity block, and if one of those writes fails, then you no longer have a
working array.  Some data blocks in that stripe cannot be recovered.
So we need to make sure that admin knows the array is dead and doesn't just
re-assemble and think everything is OK.

So we go ahead and record the failure.
mdadm -Af can fix it up and allow you to continue with a possibly-corrupt
array.=20


If you want other questions answered, best to include them in an Email.


I think to resolve this issue we need 2 thing.

1/ when assembling an array if any device thinks that the 'chosen' device h=
as
   failed, then don't trust that devices.
2/ Don't erase 'failed' status from dev_roles[] until the array is
optimal.

NeilBrown



--Sig_/83W6XAzvraP.h=2ebo7.dby
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuljXDnsnt1WYoG5AQK+uQ//QsJA51YYE1kKAp/7Mm+iVuieM4WHEUtr
A0ycACS2JAcC+ob3tD8mwD73TIJcusrh052zUsmcaeaoRfrjMpXiYAE8kZNT0XvX
SroTVgL8DI/nMYlPrMRs0+UAYeDvqwyvK1+oj0q584tzGuFk0+LOl0OnE81FowUH
EuDh/mjx3Gza6KgR4/os2yWhBatNiCHu6qD3BWDjgdZHyN4KTgZxSPKLu6532xX5
jxKOGmopiJhExw3djvRTWa0zTrkYajsHAwu0gefiz0Pb2KJsT6asL8Ah6rG6w6wr
GkthN9gt7TYjZU6pTOr4gC0j56Lfbie6GySUYIfMrhVDeLIUss0im5Dz5UTXs6JQ
8pExj7eugNsyDz3Xy/hY1g86cFNS/gKE66tXQdVycFe/yBYtJAYCHiAQ/Ecv9PD5
skEnNGTfBM5SbMry7Z9rYt21BsECvIxwkXZdfw9nZ7Tj/fuOsYqvxG3P82cax8MO
EJmWv43bg1+Tf6kXe9gyUMjUZQPoNm0/agXWRSotaEoAWxl1RaFmgfjclkCWCtdK
nn55TzPYsi1LY1P3rBiVr92ALpDDnICdoYf7ztoSvKIk/ArcnVaRYeoPVPVHK3TR
KZQWZU9T5zkan7tBz2zx4Vl5auW7EQLC7J+bDi8FIWqY6zoC6VoMTkSyJZswKrHr
OzW7aFQNQ+w=
=OEFs
-----END PGP SIGNATURE-----

--Sig_/83W6XAzvraP.h=2ebo7.dby--
