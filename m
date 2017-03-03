From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 10/14] md/raid1: stop using bi_phys_segment
Date: Fri, 03 Mar 2017 11:34:31 +1100
Message-ID: <8737evnqp4.fsf@notabene.neil.brown.name>
References: <148721992248.7521.17160361058957519076.stgit@noble> <148721994272.7521.4656357457037580183.stgit@noble> <CACVXFVMZqivgG39HBAjPKE+CJ3=nXZ3fD0XfujeUbe+_3J9HLg@mail.gmail.com> <87bmtws90u.fsf@notabene.neil.brown.name> <CACVXFVPf6qoaEWcv_s4n=2V9E=Jqfv3QE+ZpXVALdiiWTjh63Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVXFVPf6qoaEWcv_s4n=2V9E=Jqfv3QE+ZpXVALdiiWTjh63Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Feb 21 2017, Ming Lei wrote:

> On Tue, Feb 21, 2017 at 8:05 AM, NeilBrown <neilb@suse.com> wrote:
>> On Mon, Feb 20 2017, Ming Lei wrote:
>>
>>> On Thu, Feb 16, 2017 at 12:39 PM, NeilBrown <neilb@suse.com> wrote:
>>>>
>>>> +static void inc_pending(struct r1conf *conf, sector_t start_next_window,
>>>> +                       sector_t bi_sector)
>>>> +{
>>>> +       /* The current request requires multiple r1_bio, so
>>>> +        * we need to increment the pending count, and the corresponding
>>>> +        * window count.
>>>> +        */
>>>> +       spin_lock(&conf->resync_lock);
>>>> +       conf->nr_pending++;
>>>
>>> Just be curious, in current code 'nr_pending' is increased in wait_barrier(),
>>> and looks this patch introduces inc_pending() to do that on each r10_bio, but
>>> not see any change in wait_barrier(), so that means there might be issue in
>>> current implementation about operating on this counter?
>>
>> Did you read the more detailed description in the previous raid10.c
>> patch?
>> This patch follows the same logic as that patch.
>
> OK, I see the point now:
>
> - for the 1st r1_bio, conf->nr_pending is increased in wait_barrier()
> - for the others, conf->nr_pending is increased in inc_pending().
>
> Also I have another question:
>
> - before this patch, both number of requests in windows
> are increased only for WRITE I/O(see wait_barrier()), and decreased
> for both READ/WRITE in complete path(see allow_barrier())

For a READ request, ->start_next_window is zero, so allow_barrier()
doesn't decrease the window counters.
So they are only increased and decreased for WRITE request.

>
> - after this patch, except for the 1st r1_bio, number of requests in
> windows are increased for both WRITE/READ I/O, and decreased
> for both READ/WRITE too.

Why do you think READ requests now increase the number of requests in a
window?

NeilBrown

>
> Could you explain a bit about this change?
>
> Thanks,
> Ming Lei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli4uhcACgkQOeye3VZi
gbku/g//YnysbZd6aBXyw1qaqPQ0eNlq2QHdzD2KRpWA1Uf470SnT5uyrRde+CAk
90YCuxZ88E5QhyO7qOUvbCzNDWt0UFc5J0RNG+wnb9A8YeF2lqLijxetF9kmLpS9
rdkiRUX3RIXJTNZ6AYmMHlolPr2WCk6ZR8tIiguhFw46K9MzaMMcztzyNGIB07Er
JrpP1hxzs2c9sp2NKHe3QOceVhNFFMy9VgQXGIJUavesXk4Zmds2RzoW2jSFkT7n
e36nJlzW9DdtegGAHEB9DedOd401HXrcRDmW2C0iR0ZXr5ZY3+7PG5nyGq65bOyT
v6iJw79sJqpu2dPc0/6YsvrkAuzApIHWq6PncgHtuc0F38q8JgfUrQ07U4KbJG+J
yMER9ypFeZKzKtMVKLXJL6x6wiLokGhEGUPXsogjmgkvaoWXMcWH1RAtzM+jWC/T
79HBvizP0GdlGXRTmMVZPt7pZjXjDnsfS2BBEbcm43Boas343jbekpsfdrYvriWJ
3gr0oSgfc15rP2I15O6JzL4vwCbWgKXy1OSQzm26ojUsSGlXusAQZFKcZPgCSSHv
oLu5YifvOJAh+yrozmHspEV7o6fe7pBHE3UEzLx5gy61uDNzDqWUIiuPzGVfkHoJ
bpxR8/m9k1AOI5nwbg3Y/8s+agb1syPemC0uQ9LXx0c8XmeoXoA=
=Kbm0
-----END PGP SIGNATURE-----
--=-=-=--
