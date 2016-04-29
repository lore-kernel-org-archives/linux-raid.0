From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 08/13] md: set MD_CHANGE_PENDING in a spinlocked region
Date: Fri, 29 Apr 2016 11:26:32 +1000
Message-ID: <87eg9purw7.fsf@notabene.neil.brown.name>
References: <1461221895-20688-1-git-send-email-gqjiang@suse.com> <1461722186-11023-1-git-send-email-gqjiang@suse.com> <20160427152753.GB17061@kernel.org> <57217BAF.5060702@suse.com> <20160428035802.GA90901@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160428035802.GA90901@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 28 2016, Shaohua Li wrote:

> On Wed, Apr 27, 2016 at 10:55:43PM -0400, Guoqing Jiang wrote:
>>=20
>>=20
>> On 04/27/2016 11:27 AM, Shaohua Li wrote:
>> >On Tue, Apr 26, 2016 at 09:56:26PM -0400, Guoqing Jiang wrote:
>> >>Some code waits for a metadata update by:
>> >>
>> >>1. flagging that it is needed (MD_CHANGE_DEVS or MD_CHANGE_CLEAN)
>> >>2. setting MD_CHANGE_PENDING and waking the management thread
>> >>3. waiting for MD_CHANGE_PENDING to be cleared
>> >>
>> >>If the first two are done without locking, the code in md_update_sb()
>> >>which checks if it needs to repeat might test if an update is needed
>> >>before step 1, then clear MD_CHANGE_PENDING after step 2, resulting
>> >>in the wait returning early.
>> >>
>> >>So make sure all places that set MD_CHANGE_PENDING are protected by
>> >>mddev->lock.
>> >>
>> >>Reviewed-by: NeilBrown <neilb@suse.com>
>> >>Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> >>---
>> >>V3 changes:
>> >>1. use spin_lock_irqsave/spin_unlock_irqrestore in error funcs and
>> >>    raid10's __make_request
>> >shouldn't other places use spin_lock_irq/spin_unlock_irq? interrupt can=
 occur
>> >after you do spin_lock(), and if it's md_error, we deadlock.
>>=20
>> It could possible in theory if func was interrupted by md_error after it
>> called spin_lock,
>> but seems lots of place in md.c also use spin_lock/unlock for mddev->loc=
k,
>> take
>> md_do_sync and md_update_sb as example, both of them used
>> spin_lock(&mddev->lock)
>> and spin_unlock(&mddev->lock) before.
>>=20
>> So I guess it will not cause trouble, otherwise, then we need to change =
all
>> the usages of
>> spin_lock/unlock(&mddev->lock), or introduce a new lock for this scenari=
o. I
>> am not sure
>> which one is more acceptable.
>
> It doesn't cause trouble, because no interrupt/bh uses lock before. But n=
ow we
> use it in softirq, that's the difference. Please enable lockdep, I think =
it
> will complain. either we change all the locking to irq save or introducin=
g a
> new lock. either is ok.

Thanks for catching this!

As you say, the straight forward solution is change all the current
  spin_lock(&mddev->lock);
to
  spin_lock_irq(&mddev->lock);

and similar for unlock.  Except where it can be called from interrupts
we have to use spin_lock_irqsave().

There is another option that occurs to me.  Not sure if it is elegant or
ugly, so I'm keen to see what you think.

In the places where were set MD_CHANGE_PENDING and one other bit -
either MD_CHANGE_DEVS or MD_CHANGE_CLEAN - we could use set_mask_bits
to set them both atomically.

  set_mask_bits(&mddev->flags, BIT(MD_CHANGE_PENDING) | BIT(MD_CHANGE_DEVS)=
);

Then in md_update_sb, when deciding whether to loop back to "repeat:" we
use a new "bit_clear_unless".

#define bit_clear_unless(ptr, _clear, _test)			\
({								\
	const typeof(*ptr) clear =3D (_clear), test =3D (_test);	\
	typeof(*ptr) old, new;					\
								\
	do {							\
		old =3D ACCESS_ONCE(*ptr);			\
		new =3D old & ~clear;				\
	} while (!(old & test) && cmpxchg(ptr, old, new) !=3D old);\
								\
	!(old & test);							\
})

The code in md_update_sb() would be

 if (mddev->in_sync !=3D sync_req ||
     !bit_clear_unless(&mddev->flags, BIT(MD_CHANGE_PENDING),
                       BIT(MD_CHANGE_DEVS)|BIT(MD_CHANGE_CLEAN)))
        goto repeat;


So if either DEV or CLEAN we set, PENDING would not be cleared and the
code would goto repeat.

What do you think?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXIrhIAAoJEDnsnt1WYoG5clEQAKeJR+SUlaZTBpxg8eBrCZul
iZjI4AI7x1fovyN5abi+53W3Wmbc7H1gG3k5LW/9N+Ohb9+5FVtB0tMzYTlgUqyt
/1gsflUqi16018WGjcsyFRHvGlFTIsGmEEhlWL8Q/5lvBnL4nntHJKT0FvDTYtrz
rBAybDl6ld4DvwVq+slKS6fHSSKVo0Frk/bKSSdtG825svxWbsFrBGe8d6iS6XVl
cDolHRZS7fQwK1UtNLpsUCqC4k7u+uzS7qMJ3VsutJrmYSf+kbk6VAQ1jgXjDgfV
nrC+mHw994imFpjH/MeS5DaJBh0EAZx8gPDq58myVzHVlGi6QX4k+2VO7Y4m9w13
Uf0fF2yv54hE+IpkIOdu+c2Z3GQvFpQZvSOsVKGNRlk0ju1vGusbYjWkPAulbsFn
/AU3XYOQSeD1I1MWXAbbX8lYw/SqNFRmW2fdNkw+do5+rreuXGqEXFz18cROvCv6
/HN2pxTepSzA/ibCeke+KtCuQ06nzoPjUdAtz664GtPnekMYG9crSKmZYVnU6hka
Om+ASsPe8VxM2hBLLGJiY8S8d20Sdon1RG3bsNmeiAnwur8o5IE6wa2DryvbzMKM
7+eUgcbW0kOsQPennSoG4rWyfsFTBWcE32ESLYzorB3sxcK6HiaeQRTG/GaSDVu6
RUCVwdidvuAemwKNaP31
=JH+4
-----END PGP SIGNATURE-----
--=-=-=--
