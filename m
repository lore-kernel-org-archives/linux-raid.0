From: chris <tknchris@gmail.com>
Subject: Re: Weird Issue with raid 5+0
Date: Mon, 8 Mar 2010 01:16:49 -0500
Message-ID: <31e44a111003072216p74c5887v5734beebfb00d083@mail.gmail.com>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
	 <20100221164805.5bdc2d60@notabene.brown>
	 <31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
	 <20100221191640.39b68b01@notabene.brown>
	 <20100308165021.6529fe6d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100308165021.6529fe6d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Interesting, I moved to raid6 on the machine I was working on because
it was similar enough and I had a deadline to meet. I would still be
interested in testing this though. With your approval I would like to
copy xen-devel on this thread so that we can hopefully put together a
fix. Thanks again for your help previously and for what looks to be
the solution :)

- chris

On Mon, Mar 8, 2010 at 12:50 AM, Neil Brown <neilb@suse.de> wrote:
> On Sun, 21 Feb 2010 19:16:40 +1100
> Neil Brown <neilb@suse.de> wrote:
>
>> On Sun, 21 Feb 2010 02:26:42 -0500
>> chris <tknchris@gmail.com> wrote:
>>
>> > That is exactly what I didn't want to hear :( I am running
>> > 2.6.26-2-xen-amd64. Are you sure its a kernel problem and nothing =
to
>> > do with my chunk/block sizes? If this is a bug what versions are
>> > affected, I'll build a new domU kernel and see if I can get it wor=
king
>> > there.
>> >
>> > - chris
>>
>> I'm absolutely sure it is a kernel bug.
>
> And I think I now know what the bug is.
>
> A patch was recently posted to dm-devel which I think addresses exact=
ly this
> problem.
>
> I reproduce it below.
>
> NeilBrown
>
> -------------------
> If the lower device exposes a merge_bvec_fn,
> dm_set_device_limits() restricts max_sectors
> to PAGE_SIZE "just to be safe".
>
> This is not sufficient, however.
>
> If someone uses bio_add_page() to add 8 disjunct 512 byte partial
> pages to a bio, it would succeed, but could still cross a border
> of whatever restrictions are below us (e.g. raid10 stripe boundary).
> An attempted bio_split() would not succeed, because bi_vcnt is 8.
>
> One example that triggered this frequently is the xen io layer.
>
> raid10_make_request bug: can't convert block across chunks or bigger =
than 64k 209265151 1
>
> Signed-off-by: Lars <lars.ellenberg@linbit.com>
>
>
> ---
> =A0drivers/md/dm-table.c | =A0 12 ++++++++++--
> =A01 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 4b22feb..c686ff4 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -515,14 +515,22 @@ int dm_set_device_limits(struct dm_target *ti, =
struct dm_dev *dev,
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Check if merge fn is supported.
> - =A0 =A0 =A0 =A0* If not we'll force DM to use PAGE_SIZE or
> + =A0 =A0 =A0 =A0* If not we'll force DM to use single bio_vec of PAG=
E_SIZE or
> =A0 =A0 =A0 =A0 * smaller I/O, just to be safe.
> =A0 =A0 =A0 =A0 */
>
> - =A0 =A0 =A0 if (q->merge_bvec_fn && !ti->type->merge)
> + =A0 =A0 =A0 if (q->merge_bvec_fn && !ti->type->merge) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0limits->max_sectors =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0min_not_zero(limits->m=
ax_sectors,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 (unsigned int) (PAGE_SIZE >> 9));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Restricting max_sectors is not enoug=
h.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If someone uses bio_add_page to ad=
d 8 disjunct 512 byte
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* partial pages to a bio, it would s=
ucceed,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but could still cross a border of =
whatever restrictions
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* are below us (e.g. raid0 stripe bo=
undary). =A0An attempted
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* bio_split() would not succeed, bec=
ause bi_vcnt is 8. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 limits->max_segments =3D 1;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return 0;
> =A0}
> =A0EXPORT_SYMBOL_GPL(dm_set_device_limits);
> --
> 1.6.3.3
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
