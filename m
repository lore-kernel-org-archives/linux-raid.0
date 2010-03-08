From: chris <tknchris@gmail.com>
Subject: Re: Weird Issue with raid 5+0
Date: Mon, 8 Mar 2010 10:35:57 -0500
Message-ID: <31e44a111003080735t4ddf7c63uaa517ad6522cca67@mail.gmail.com>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>
	<20100221164805.5bdc2d60@notabene.brown>
	<31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>
	<20100221191640.39b68b01@notabene.brown>
	<20100308165021.6529fe6d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20100308165021.6529fe6d@notabene.brown>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: Xen-Devel List <xen-devel@lists.xensource.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

I forwarding this to xen-devel because it appears to be a bug in dom0 kerne=
l.

I recently experienced a strange issue with software raid1+0 under Xen
on a new machine. I was getting corruption in my guest volumes and
tons of kernel messages such as:

[305044.571962] raid0_make_request bug: can't convert block across
chunks or bigger than 64k 14147455 4

The full thread is located at http://marc.info/?t=3D126672694700001&r=3D1&w=
=3D2
Detailed output at http://pastebin.com/f6a52db74

It appears after speaking with the linux-raid mailing list that this
is due a bug which has been fixed but the fix is not included in the
dom0 kernel. I'm not sure what sources kernel 2.6.26-2-xen-amd64 is
based on, but since xenlinux is still at 2.6.18 I was assuming that
this bug would still exist.

My questions for xen-devel are:

Can you tell me if there is any dom0 kernel where this issue is fixed?
Is there anything I can do to help get this resolved? Testing? Patching?

- chrris

On Mon, Mar 8, 2010 at 12:50 AM, Neil Brown <neilb@suse.de> wrote:
> On Sun, 21 Feb 2010 19:16:40 +1100
> Neil Brown <neilb@suse.de> wrote:
>
>> On Sun, 21 Feb 2010 02:26:42 -0500
>> chris <tknchris@gmail.com> wrote:
>>
>> > That is exactly what I didn't want to hear :( I am running
>> > 2.6.26-2-xen-amd64. Are you sure its a kernel problem and nothing to
>> > do with my chunk/block sizes? If this is a bug what versions are
>> > affected, I'll build a new domU kernel and see if I can get it working
>> > there.
>> >
>> > - chris
>>
>> I'm absolutely sure it is a kernel bug.
>
> And I think I now know what the bug is.
>
> A patch was recently posted to dm-devel which I think addresses exactly t=
his
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
> raid10_make_request bug: can't convert block across chunks or bigger than=
 64k 209265151 1
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
> @@ -515,14 +515,22 @@ int dm_set_device_limits(struct dm_target *ti, stru=
ct dm_dev *dev,
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Check if merge fn is supported.
> - =A0 =A0 =A0 =A0* If not we'll force DM to use PAGE_SIZE or
> + =A0 =A0 =A0 =A0* If not we'll force DM to use single bio_vec of PAGE_SI=
ZE or
> =A0 =A0 =A0 =A0 * smaller I/O, just to be safe.
> =A0 =A0 =A0 =A0 */
>
> - =A0 =A0 =A0 if (q->merge_bvec_fn && !ti->type->merge)
> + =A0 =A0 =A0 if (q->merge_bvec_fn && !ti->type->merge) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0limits->max_sectors =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0min_not_zero(limits->max_s=
ectors,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (=
unsigned int) (PAGE_SIZE >> 9));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Restricting max_sectors is not enough.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If someone uses bio_add_page to add 8 =
disjunct 512 byte
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* partial pages to a bio, it would succe=
ed,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but could still cross a border of what=
ever restrictions
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* are below us (e.g. raid0 stripe bounda=
ry). =A0An attempted
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* bio_split() would not succeed, because=
 bi_vcnt is 8. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 limits->max_segments =3D 1;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return 0;
> =A0}
> =A0EXPORT_SYMBOL_GPL(dm_set_device_limits);
> --
> 1.6.3.3
>
