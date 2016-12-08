From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Thu, 08 Dec 2016 14:17:18 +1100
Message-ID: <871sxj2jpd.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <CAMGffE=L_XziWyV+wCJFqKj+v_ahOPNSugZ3uY1q5ixd4iv2fQ@mail.gmail.com> <af7ae0a8-eb73-0070-4280-8758433ad500@suse.de> <CAMGffEmc_6o+Lgq3iJsCUyn6K=5S2w8pnrVDhXNBJxaKxd1Teg@mail.gmail.com> <519e773d-e6e6-5d79-7224-ef94ef7c7a93@suse.de> <CAMGffEktp+raca2fYPu8fC5nxUrhGLKwjJhtHwXV2Bh_m5oViA@mail.gmail.com> <dd068837-6873-ab1b-3c25-d4dbf4ad2ec4@suse.de> <CAMGffEkbddHsJ4LSWcd1DmueM8XTm1pUiowa=_MUHmysVEFN_w@mail.gmail.com> <CAMGffE=T15eLaROLCDGBA_OxQgUZbo22LQZJuSji=Z=rZRGr6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffE=T15eLaROLCDGBA_OxQgUZbo22LQZJuSji=Z=rZRGr6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>, Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08 2016, Jinpu Wang wrote:

> On Tue, Nov 29, 2016 at 12:15 PM, Jinpu Wang
> <jinpu.wang@profitbricks.com> wrote:
>> On Mon, Nov 28, 2016 at 10:10 AM, Coly Li <colyli@suse.de> wrote:
>>> On 2016/11/28 =E4=B8=8B=E5=8D=885:02, Jinpu Wang wrote:
>>>> On Mon, Nov 28, 2016 at 9:54 AM, Coly Li <colyli@suse.de> wrote:
>>>>> On 2016/11/28 =E4=B8=8B=E5=8D=884:24, Jinpu Wang wrote:
>>>>>> snip
>>>>>>>>>
>>>>>>>>> every time nr_pending is 1 bigger then (nr_queued + 1), so seems =
we
>>>>>>>>> forgot to increase nr_queued somewhere?
>>>>>>>>>
>>>>>>>>> I've noticed (commit ccfc7bf1f09d61)raid1: include bio_end_io_lis=
t in
>>>>>>>>> nr_queued to prevent freeze_array hang. Seems it fixed similar bu=
g.
>>>>>>>>>
>>>>>>>>> Could you give your suggestion?
>>>>>>>>>
>>>>>>>> Sorry, forgot to mention kernel version is 4.4.28

>
> I continue debug the bug:
>
> 20161207

>   nr_pending =3D 948,
>   nr_waiting =3D 9,
>   nr_queued =3D 946, // again we need one more to finished wait_event.
>   barrier =3D 0,
>   array_frozen =3D 1,

> on conf->bio_end_io_list we have 91 entries.

> on conf->retry_list we have 855

This is useful.  It confirms that nr_queued is correct, and that
nr_pending is consistently 1 higher than expected.
This suggests that a request has been counted in nr_pending, but hasn't
yet been submitted, or has been taken off one of the queues but has not
yet been processed.

I notice that in your first email the Blocked tasks listed included
raid1d which is blocked in freeze_array() and a few others in
make_request() blocked on wait_barrier().
In that case nr_waiting was 100, so there should have been 100 threads
blocked in wait_barrier().  Is that correct?  I assume you thought it
was pointless to list them all, which seems reasonable.

I asked because I wonder if there might have been one thread in
make_request() which was blocked on something else.  There are a couple
of places when make_request() will wait after having successfully called
wait_barrier().  If that happened, it would cause exactly the symptoms
you report.  Could you check all blocked threads carefully please?


There are other ways that nr_pending and nr_queued can get out of sync,
though I think they would result in nr_pending being less than
nr_queued, not more.

If the presense of a bad block in the bad block log causes a request to
be split into two r1bios, and if both of those end up on one of the
queues, then they would be added to nr_queued twice, but to nr_pending
only once.  We should fix that.


>
> list -H 0xffff8800b96acac0 r1bio.retry_list -s r1bio
>
> ffff8800b9791ff8
> struct r1bio {
>   remaining =3D {
>     counter =3D 0
>   },
>   behind_remaining =3D {
>     counter =3D 0
>   },
>   sector =3D 18446612141670676480, // corrupted?
>   start_next_window =3D 18446612141565972992, //ditto

I don't think this is corruption.

> crash> struct r1conf 0xffff8800b9792000
> struct r1conf {
  ....
>   retry_list =3D {
>     next =3D 0xffff8800afe690c0,
>     prev =3D 0xffff8800b96acac0
>   },

The pointer you started at was at the end of the list.
So this r1bio structure you are seeing is not an r1bio at all but the
memory out of the middle of the r1conf, being interpreted as an r1bio.
You can confirm this by noticing that retry_list in the r1bio:

>   retry_list =3D {
>     next =3D 0xffff8800afe690c0,
>     prev =3D 0xffff8800b96acac0
>   },

is exactly the same as the retry_list in the r1conf.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhI0L4ACgkQOeye3VZi
gbm1xg//bglInICeSuzDtH8pqSrsjimTt169wqR0aR+nhWOYs071trj4vHU+wTQy
fnEorplZoGOD8N/I1cOQN67K2tmG+Dlt5J6hGHc7E8X07qlan6XaEkqyPIzXPLBm
3KKMwGMTPnLHh3YwWEF6rnSwH4YdRhFY39+iq4stZVI+l0Iw1sKqu8jKvOGG+I1j
Kj5iiObtCHQxxzpPLHVa++rswe1GRZKBbyPZriXFdzk7UqZcByb+iGNEXINDpZnn
4oKSfOVx4OVs3VxFqu5yXgkIFrt6mzFLko8k6gtXUfCT4+gGZofWFsHTQ8Z2kcux
hg5bZwsUAWyqinF6ICq4ig7m+AaKxOUDwU2/tVt+YVqM5NezMAWxgLWmJZDATncF
i8mQFu+La63K7BrZwqHpEXfxvdbSGNr1BZf9vlhM/R2ANTq4W24buSi40aw1OaEV
Lt7lxcHnV8ra5mx/dWR5GojEAIU0cq/Nj+BdRcSJB41Lbfh63a/0YVDffHRoFEED
MPcPE+Y8PA6dA64DoRFyoxP3FeMO36QK3PcCipyHvRqtHoG4ARv2/9DjW8PclQbT
yhAh4L2z6WxwB9t2lxwODyj2sx2cHFjxTHXX6EPwEuQhcT0XxSbEX6dZC3BsUHUX
b1WdfAoz9FmsSmzjc5y1m0YZbeAiJFktQaO2KmNMV0jkGw3hTZE=
=Yf/+
-----END PGP SIGNATURE-----
--=-=-=--
