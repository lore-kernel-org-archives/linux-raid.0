From: NeilBrown <neilb@suse.com>
Subject: Re: Bisected: Kernel 4.14 + has 3 times higher write IO latency than Kernel 4.4 with raid1
Date: Tue, 20 Aug 2019 10:27:58 +1000
Message-ID: <87pnl0he9d.fsf@notabene.neil.brown.name>
References: <CAMGffEkotpvVz8FA78vNFh0qZv3kEMNrXXfVPEUC=MhH0pMCZA@mail.gmail.com> <0a83fde3-1a74-684c-0d70-fb44b9021f96@molgen.mpg.de> <CAMGffE=_kPoBmSwbxvrqdqbhpR5Cu2Vbe4ArGqm9ns9+iVEH_g@mail.gmail.com> <CAMGffEkcXcQC+kjwdH0iVSrFDk-o+dp+b3Q1qz4z=R=6D+QqLQ@mail.gmail.com> <87h86vjhv0.fsf@notabene.neil.brown.name> <CAMGffEnKXQJBbDS8Yi0S5ZKEMHVJ2_SKVPHeb9Rcd6oT_8eTuw@mail.gmail.com> <CAMGffEkfs0KsuWX8vGY==1dym78d6wsao_otSjzBAPzwGtoQcw@mail.gmail.com> <87blx1kglx.fsf@notabene.neil.brown.name> <CAMGffE=cpxumr0QqJsiGGKpmZr+4a0BiCx3n0_twa5KPs=yX1g@mail.gmail.com> <CAMGffEm41+-DvUu_MhfbVURL_LOY8KP1QkTWDcFf7nyGLK7Y3A@mail.gmail.com> <CAMGffEn8FkjoQjno0kDzQcr6pcSXr3PGGfsErnhv0HN0+zEwhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMGffEn8FkjoQjno0kDzQcr6pcSXr3PGGfsErnhv0HN0+zEwhg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc: Alexandr Iarygin <alexandr.iarygin@cloud.ionos.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Paul Menzel <pmenzel@molgen.mpg.de>, Neil F Brown <nfbrown@suse.com>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Aug 16 2019, Jinpu Wang wrote:

> On Wed, Aug 7, 2019 at 2:35 PM Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
>>
>> On Wed, Aug 7, 2019 at 8:36 AM Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
>> >
>> > On Wed, Aug 7, 2019 at 1:40 AM NeilBrown <neilb@suse.com> wrote:
>> > >
>> > > On Tue, Aug 06 2019, Jinpu Wang wrote:
>> > >
>> > > > On Tue, Aug 6, 2019 at 9:54 AM Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
>> > > >>
>> > > >> On Tue, Aug 6, 2019 at 1:46 AM NeilBrown <neilb@suse.com> wrote:
>> > > >> >
>> > > >> > On Mon, Aug 05 2019, Jinpu Wang wrote:
>> > > >> >
>> > > >> > > Hi Neil,
>> > > >> > >
>> > > >> > > For the md higher write IO latency problem, I bisected it to these commits:
>> > > >> > >
>> > > >> > > 4ad23a97 MD: use per-cpu counter for writes_pending
>> > > >> > > 210f7cd percpu-refcount: support synchronous switch to atomic mode.
>> > > >> > >
>> > > >> > > Do you maybe have an idea? How can we fix it?
>> > > >> >
>> > > >> > Hmmm.... not sure.
>> > > >> Hi Neil,
>> > > >>
>> > > >> Thanks for reply, detailed result in line.
>> > >
>> > > Thanks for the extra testing.
>> > > ...
>> > > > [  105.133299] md md0 in_sync is 0, sb_flags 2, recovery 3, external
>> > > > 0, safemode 0, recovery_cp 524288
>> > > ...
>> > >
>> > > ahh - the resync was still happening.  That explains why set_in_sync()
>> > > is being called so often.  If you wait for sync to complete (or create
>> > > the array with --assume-clean) you should see more normal behaviour.
>> > I've updated my tests accordingly, thanks for the hint.
>> > >
>> > > This patch should fix it.  I think we can do better but it would be more
>> > > complex so no suitable for backports to -stable.
>> > >
>> > > Once you confirm it works, I'll send it upstream with a
>> > > Reported-and-Tested-by from you.
>> > >
>> > > Thanks,
>> > > NeilBrown
>> >
>> > Thanks a lot, Neil, my quick test show, yes, it fixed the problem for me.
>> >
>> > I will run more tests to be sure, will report back the test result.
>> Hi Neil,
>>
>> I've run our regression tests with your patch, everything works fine
>> as expected.
>>
>> So Reported-and-Tested-by: Jack Wang <jinpu.wang@cloud.ionos.com>
>>
>> Thank you for your quick fix.
>>
>> The patch should go to stable 4.12+
>
> Hi Neil,
>
> I hope you're doing well, just a soft ping? do you need further
> testing from my side?

Thanks for the reminder.  I've sent out the patch now.

NeilBrown


>
> Please let me know how can we move the fix forward.
>
> Thanks,
> Jack Wang

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl1bPo4ACgkQOeye3VZi
gblYVg/8Dexb3Ia8ZpTQaD7fgTUi9kZ89sfPTzDBTxpcXiuYbGm2F2cCk3Uf12R4
Zfdr1EFajzmPo98CVCNcB7pzkbHqvtH5rx1XwxV6gQ0pIGJzWp3pnDSnfoLalj4k
BeKs/zWjo5NHyUH0VTXQJmOhKuSk7RCSkEfNJVdV0q07ShK1uegy2khv7PEfmhdl
5e8vsf3aXNDfZnparqaY6fJanrMvv+Psq0lQUtQYVTLgk8Ty9NOTDh07aRoj2ZjJ
u3Pxyt80jMIgkVOiBghdziDnapxCixPydXs8Pdj5y9IbSiii8noRDiHDnN3dLgg3
6VWy1uk3cp83Op0Nm+6Fe/IgPTRFZN8K9UGb1woOTsP4Abpe6K275k41CkgZ5HQF
TsFD0icnEnjHH6O5yYn4oGLWf/LEl1H2B1sWN7K/HP+RzQNvwKistYTuxpacShwa
L4xKm3b3anaQoMNm+rC+SfsVWjY0lFcFcy+sfZytcr2BrBfSgV5efD1aMeEKhtbm
jLkI15kvfmPbl+mqMOc3A4B7jT3I/Y5J2Vgv5KIWCrm/4zrDN5TZ6AU4Yy4B+rMi
QxrMcKYkXTvKF3jz56s3rHtgyLs6kopXVcX3Krqw4n7SIhV8Q0G/4nTLV0DPryAr
lV1dRxQi4BuL5adBWDd6TDxXqPO6ukPXVF3lqbVz0e4x6duIjK0=
=TyQL
-----END PGP SIGNATURE-----
--=-=-=--
