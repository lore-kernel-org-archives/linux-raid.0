From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Fri, 08 Jul 2016 09:41:27 +1000
Message-ID: <87poqpf23c.fsf@notabene.neil.brown.name>
References: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>, =?utf-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Jun 27 2016, Alexander Lyakas wrote:

> When we call wait_barrier, we might have some bios waiting
> in current->bio_list, which prevents the array_freeze call to
> complete. Those can only be internal READs, which have already
> passed the wait_barrier call (thus incrementing nr_pending), but
> still were not submitted to the lower level, due to generic_make_request
> logic to avoid recursive calls. In such case, we have a deadlock:
> - array_frozen is already set to 1, so wait_barrier unconditionally waits, so
> - internal READ bios will not be submitted, thus freeze_array will
> never completes
>
> This problem was originally fixed in commit:
> d6b42dc md/raid1,raid10: avoid deadlock during resync/recovery.
>
> But then it was broken in commit:
> b364e3d raid1: Add a field array_frozen to indicate whether raid in
> freeze state.

Thanks for the great analysis.
I think this primarily a problem in generic_make_request().  It queues
requests in the *wrong* order.

Please try the patch from
  https://lkml.org/lkml/2016/7/7/428

and see if it helps.  If two requests for a raid1 are in the
generic_make_request queue, this patch causes the sub-requests created
by the first to be handled before the second is attempted.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXfuinAAoJEDnsnt1WYoG5k3kQALTl96/dGiGT42D245e0DNFx
Avuu9n37Q9rj+Q37/xbwzMUw6pmd3acUgg1UrA2fy+Rc95lpC2w/w3vl9E/3R+oI
nHJPUrdamRDTvdIbMuxi6Hl9sI4PSJApFEoYz62zfdE3NLiMeXEoK2lSq1q+ugAV
0Ft4Y/qaIe1fM0KU8x58+K4brjUg7Y9AijsoHjhk6UF+2Xsb7p3BulT61q9+Q1pO
VBFhI/AByMcA+F+C2+9qcvjMLjixtR/kdW9/utD+Se9j5ZMHABGLalv9OUJio1Zy
NDrw/vN2gj8CsueXpAnBW8KgaKbZe9subTaZLyoI73+4pOYCKRnZCMzoVklvdeSE
QdiyjeXkrk0nx5jWdt8OJiixDhLUudZBZwPo+cwqbITEkSQjx1vIgiv+BnfSJlvF
hAtquh0tNNLjl8cHyWZ8NyY0QfpxfTwdWKK+rjWxJdBY3sM7SElg72rFxewhtL0I
mVsDmClCf732cZgcOxuEs0cl7MuBRDxZMX/JmMAl72BpnqqhtJPZ6L2kdizjsnyx
FKxJcbjZTH3NIcP0GMhAnhkqXU/jjtEKV+1WG3BvI5CBRmvxmUufX8q+3Bi402Dj
DDNXP1aw/PNKk97XkKm5LTi2QKq844Jk73dThOIKuYUGMAUus5qF9Pl3Ck/lwEgs
qzwcSQl51Rj+GgmnXOjq
=DSY/
-----END PGP SIGNATURE-----
--=-=-=--
