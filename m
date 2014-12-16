From: NeilBrown <neilb@suse.de>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch
 checksum
Date: Wed, 17 Dec 2014 08:49:21 +1100
Message-ID: <20141217084921.360ca442@notabene.brown>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
	<20141029200501.1f01269d@notabene.brown>
	<CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
	<CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com>
	<20141103165217.3bfd3d3e@notabene.brown>
	<CAK-d5daq+-PbX1s81h01x7GdVDCijyzzPaeRAOCctEXTNideCw@mail.gmail.com>
	<20141125095052.51f8eadc@notabene.brown>
	<CAK-d5dZnWpmyPfWTGB74wHojeywdiXDnT6Fs0yqYqn7bJpSL-Q@mail.gmail.com>
	<CAK-d5dY4QEDupxjkon_+6z0Z7ggPKv=PLF60zTkeSBsbd4+mPQ@mail.gmail.com>
	<CAK-d5dZMjbhAqgs9GOvswG6crZtrV2uSidRzt_hBJAH=m5rGKw@mail.gmail.com>
	<20141202084611.45f56d6a@notabene.brown>
	<CAK-d5dajGYxda_UFK_fBET14+KDr68km0uEKfrQVqs5oShWGfg@mail.gmail.com>
	<CAK-d5db_ubRobL=uiia_9yOFA0PMovptAG8O+Y17ORT_--FsQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pXxQc7fhuBvi6RUVNC+qW_Q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5db_ubRobL=uiia_9yOFA0PMovptAG8O+Y17ORT_--FsQg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/pXxQc7fhuBvi6RUVNC+qW_Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Dec 2014 21:55:15 +0530 Anshuman Aggarwal
<anshuman.aggarwal@gmail.com> wrote:

> On 2 December 2014 at 17:26, Anshuman Aggarwal
> <anshuman.aggarwal@gmail.com> wrote:
> > It works! (Atleast on a sample 5 MB device with 5 x 1MB partitions :-)
> > will find more space on my drives and do a larger test but don't see
> > why it shouldn't work)
> > Here are the following caveats (and questions):
> > - Neil, like you pointed out, the power of 2 chunk size will probably
> > need a code change (in the kernel or only in the userspace tool?)

In the kernel too.

> >     - Any performance or other reasons why a terabyte size chunk may
> > not be feasible?

Not that I can think of.

> > - Implications of safe_mode_delay
> >     - Would the metadata be updated on the block device be written to
> > and the parity device as well?

Probably.  Hard to give a specific answer to vague question.

> >     - If the drive  fails which is the same as the drive being written
> > to, would that lack of metadata updates to the other devices affect
> > reconstruction?

Again, to give a precise answer, a detailed question is needed.  Obviously
any change would have to made in such a way to ensure that things which
needed to work, did work.


> > - Adding new devices (is it possible to move the parity to the disk
> > being added? How does device addition work for RAID4 ...is it added as
> > a zero-ed out device with parity disk remaining the same)

RAID5 or RAID6 with ALGORITHM_PARITY_0 puts the parity on the early devices.
Currently if you add a device to such an array ...... I'm not sure what it
will do.  It should be possible to make it just write zeros out.


NeilBrown


> >
> >
>=20
> Neil, sorry to try to bump this thread. Could you please look over the
> questions and address the points on the remaining items that can make
> it a working solution? Thanks


--Sig_/pXxQc7fhuBvi6RUVNC+qW_Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJCo4Tnsnt1WYoG5AQIrdQ//cUx9OA8Fgor+DTdmqkH446MK81iB75ug
4Eout3RinD06OjiWI+MneqDpdqCYY1eLaB2AG1LPfB8/kjvlaGdT0mVfr/2uTmjd
KTk5MMwvhTd8Yw+lKfDwG3uboYmLjcWlxGtLHTMtIw0FmiWKOfxBJ8Erqh8w/Nz+
i05JA8fV5CgEANwkhMAw8Cq8b3DILeZ/dDab39rbv98/6EuOb747AY1/a01xQf2Q
FFee5LMCwRTDGVaiX+cBTA1NabVFZy0k3+3BiETAQIu3HKRAmphzr7QL6xVWF53Q
0Id5FOj7HWr12XTHADolyN5CPKY77o+PQBBBKRRGxGcOEfPJR+fBbhzOucSjAPNY
PiTDpZDlUAi0NvQGevvZZ3pD5riaDxKTBpcwv+NjMK4M5EiDiBG0uLYgh8dskt6l
X6XjHpKynGZW2LlgAxHb1of144Vb/wnFCMa32Kibzjbhx4ce3YC3P29F9v+dDpDe
lNYhC6GkbW757OJ5LlPAZaNoUjNplNc1zNvpH7xEzWZRCdbdR/VjoWyzpC1BNYlG
wS4CkEmyhuMlhbzP/QAv3M6X5rcAGHoICQPb4dwIsaVEaJU1nq6d6BbASQ5QzGde
a5KPvj1QNkplCfjgcjKFV2VR44rjWtLhOYqKpg5sXvFAYbBCtyEMXjez4BpNd9vw
yksk6wzr0Ko=
=UQcn
-----END PGP SIGNATURE-----

--Sig_/pXxQc7fhuBvi6RUVNC+qW_Q--
