From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
Date: Thu, 05 Oct 2017 16:03:51 +1100
Message-ID: <87y3oq18zs.fsf@notabene.neil.brown.name>
References: <150518076229.32691.13542756562323866921.stgit@noble> <f5b2cb91-3a9e-69ba-6b01-51335ec74da1@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5b2cb91-3a9e-69ba-6b01-51335ec74da1@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Sep 30 2017, Xiao Ni wrote:

> On 09/12/2017 09:49 AM, NeilBrown wrote:
>> Hi,
>>   I looked again at the previous patch I posted which tried to mak
>>   md_update_sb() safe without taking reconfig_mutex, and realized that
>>   it had serious problems, particularly around devices being added or
>>   removed while the update was happening.
> Could you explain this in detail? What's the serious problems?

My patch allowed md_update_sb() to run without holding ->reconfig_mutex.
md_update_sb() uses rdev_for_each() in several places, so either that
list needs to be kept stable, or md_update_sb() needs to ensure it is
very careful while walking the list.

I couldn't just use a spinlock to protect the lists because one of the
rdev_for_Each calls md_super_write() on some of the devices, which is
not allowed while holding a spinlock.

I decided it was too hard to make md_update_sb() walk the list in a
fully say manner.

NeilBrown


>
> Regards
> Xiao
>>
>>   So I decided to try a different approach, which is embodied in these
>>   patches.  The md thread is now explicitly allowed to call
>>   md_update_sb() while some other thread holds the lock and
>>   waits for mddev_suspend() to complete.
>>
>>   Please test these and confirm that they still address the problem you
>>   found.
>>
>> Thanks,
>> NeilBrown
>>
>> ---
>>
>> NeilBrown (4):
>>        md: always hold reconfig_mutex when calling mddev_suspend()
>>        md: don't call bitmap_create() while array is quiesced.
>>        md: use mddev_suspend/resume instead of ->quiesce()
>>        md: allow metadata update while suspending.
>>
>>
>>   drivers/md/dm-raid.c     |    5 ++++-
>>   drivers/md/md.c          |   45 ++++++++++++++++++++++++++++++++-------------
>>   drivers/md/md.h          |    6 ++++++
>>   drivers/md/raid5-cache.c |    2 ++
>>   4 files changed, 44 insertions(+), 14 deletions(-)
>>
>> --
>> Signature
>>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnVvTgACgkQOeye3VZi
gbmVpBAAsiUbX3W8J3OAwpddO+9hmjjE0tLHtPMsUn4g6x5/ur1NdeAJg3aOPv0r
SAJIXYBp9RMmuIguQu9X2P9/fTeLFc6lvUayFMXei736RrE42v3JGwszrlWlz5Mh
GAnAMGrOj/Q/mDXUBSUkthjT7JaizATMroQ4JQqo3ROjxBn9KKLX2XjH6+h0+8Ht
2vvPp4VUiGk5Fijfg4JyeWPsVzPrnz2nBdplV6W3BnKk4xNsRL3aVYZl++89W0MB
/lEVluhpoCPgg5QEk6d8AbGY056ErwuZ/6uxxQnU7OfckVN/9KYZP4q2Ynt6jFrE
VN1R3caImWdAVNC/hMdfI02Nms4MyKnN3ECdRLDU9bVRwIz0DeFjGPp/czX+u2/M
ynlvTE6F04B3752dYbXJG/BLLqTISogofIoKFfBlQnyV41Fia7DJ2nRFgK/i/YTS
/3N+FGRPWUfXDL3v7NBlvO+2RzOBxT+JUrmVzvt+MKx3S14+Ld2HrdCeJ8dFmDr6
tIYx97lYItN9mLChzjwhVZe9z6gXvnUO4V/rJVr91zgMsFvT2ZkPB1dLD0HaIGcP
PlyX4mB582/8CPow49y69l6/qJssyLFUdPah4UgTy3uUsB+o19ue8KKrfco64Xze
ULCkrIAH4iIUw+2NnRYU9VoMg7aQNgBMBvMM0gehEmFRnosx0Ns=
=YbXX
-----END PGP SIGNATURE-----
--=-=-=--
