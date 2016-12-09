From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Fri, 09 Dec 2016 17:01:51 +1100
Message-ID: <87inqt1vzk.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <CAMGffE=L_XziWyV+wCJFqKj+v_ahOPNSugZ3uY1q5ixd4iv2fQ@mail.gmail.com> <af7ae0a8-eb73-0070-4280-8758433ad500@suse.de> <CAMGffEmc_6o+Lgq3iJsCUyn6K=5S2w8pnrVDhXNBJxaKxd1Teg@mail.gmail.com> <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de> <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com> <dd068837-6873-ab1b-3c25-d4dbf4ad2ec4@suse.de> <CAMGffEkbddHsJ4LSWcd1DmueM8XTm1pUiowa=_MUHmysVEFN_w@mail.gmail.com> <CAMGffE=T15eLaROLCDGBA_OxQgUZbo22LQZJuSji=Z=rZRGr6Q@mail.gmail.com> <871sxj2jpd.fsf@notabene.neil.brown.name> <CAMGffEntREcP-A=td4m3LRp1oHtxR=MMH_=a4N49UPvzFj-02A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEntREcP-A=td4m3LRp1oHtxR=MMH_=a4N49UPvzFj-02A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 08 2016, Jinpu Wang wrote:


This number:

>   nr_pending = {
>     counter = 1
>   },



and this number:

>   nr_pending = {
>     counter = 856
>   },

might be interesting.

There are 855 requested on the list.  Add the one that is currently
being retried give 856, which is nr_pending for the device that failed.
But nr_pending on the device that didn't fail is 1.  I would expect
zero.
When a read or write requests succeeds, rdev_dec_pending() is called
immediately so this should quickly go to zero.

It seems as though there must be a request to the loop device that is
stuck somewhere between the atomic_inc(&rdev->nr_pending) (possibly
inside read_balance) and the call to generic_make_request().
I cannot yet see how that would happen.

Can you check if the is a repeatable observation?  Is nr_pending.counter
always '1' on the loop device?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhKSM8ACgkQOeye3VZi
gbkTgQ//cESL8mIe6QiKgcO9gWYvFP6VIXUUBXm8uleeNQF1ybG/TWHNEPiMjikI
Xw/cmeHbZR1waTjHdt16SEB/9iJZBTz01yc5931OrPEo2aYPz/C9hvVm4itu7+lb
Sh5BVnTW+HI+ItTr71UIhB2zwNXrVxQvIloeIbLZv/SyOxWtVw2OSs4TY/kTMDi2
o9nirZIIPbHadqIivDiUrLhCnzsIst6wsO4FxoJC3D04vbyusJavSjtw4jvdxo8J
D+0N8gnP4NoV7DVEKpT8w0dDq1npyT6bCrCC53mqJlw/nX4rL+nbew3QF0Qop3S+
2SCL0nqefVieFNBh3eL2vJQNPykqVm/DwJ/geNyVQ3GzdAZcvKjSLenPBmehUBNp
TnklxsVTsixgjgIulD1s4c0//qby+s1PnnWI3rno0nk93RzLD2YPc4QqLxT2ovMU
J3oC9oAE690Wpe/cnvsZoZQJ8VKFtYKZhVrd1wjD9nuDLBbhfrPjKTxHt4M8KR5H
WgYqiMI5cbDG3fDs8wG3zOinIqihvxciWIlBJ/FR+n5Km0BXVcMktZgB5NWGwgRL
SNhhpkeA2V7/k+DiN0hFZeFDwBbbdRR/OK7K3ohXkW9di2Qv8grjIiNx04nKkkIr
ZEZa05pwfiTpGoyso6yUPsheqbrlFD6sfpHOjp1zzr58V2nXwUU=
=FlF/
-----END PGP SIGNATURE-----
--=-=-=--
