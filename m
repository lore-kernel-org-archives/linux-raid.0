From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Wed, 14 Dec 2011 23:14:04 -0800
Message-ID: <CABE8wwtKvNamQM3VfYFHwGQ0BhV2xBtYgqV1=Rmjc=6J3Bqogw@mail.gmail.com>
References: <20111026014240.21110.28487.stgit@notabene.brown>
	<CAA9_cmfWEnLnvrShVp3BL+WsEApS+nsWBZfao-qM2_habqFCtg@mail.gmail.com>
	<20111215171850.335da016@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111215171850.335da016@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 14, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
>> f248f8c md: create externally visible flags for supporting hot-repla=
ce.
>>
>> 'replaceable' just strikes me as a confusing name as all devices are
>> nominally "replaceable", but whether you want it to be actively
>> replaced is a different consideration. =A0What about "incumbent" to =
mark
>> the disk as currently holding a position we want it to vacate and
>> remove any potential confusion with 'replacement'.
>
> Fair point. =A0I had wondered if I should not have the flag and just =
use the
> "write_error" flag. =A0However the meaning is slightly different.
>
> I don't really like "incumbent" as it gives no indication that there =
is a
> desire to replace the device. =A0Maybe "want_replacement" ??

Yeah that works.  I was hung up on the previous scheme only differing
the in "able" vs "ment" suffix, so a "want_" prefix fits the bill.

>> 37aebb5 md/raid5: preferentially read from replacement device if pos=
sible.
[..]
>> Should this one liner be broken out for -stable?
>> Do you see a particular problem that this fixes that is already poss=
ible
> without hot-replace?

I would need to think it through a bit further, but the changelog was
sufficiently convincing so I thought I would ask.

>> Nit, not sure if it's worth fixing but this one introduces some
>> inconsistent line wrapping around logical operators... "at the end" =
vs
>> "beginning of next line"
>>
[..]
>
> Thanks.
> I almost always prefer 'at the start' as import things should be obvi=
ous.
> So I have updated 'want_replace'.

=2E..and here I've been an 'at the end' Sneetch and convinced myself
that it's easier to read...

>>
>> 2693b9e md/raid5: handle activation of replacement device when
>> recovery completes.
>>
>> I questioned not needing a barrier in raid5_end_write_request after
>> finding conf->disks[i].replacement =3D=3D NULL until I found the not=
e in
>> raid5_end_read_request about the rdev being pinned until all i/o
>> returns. =A0Maybe a similar note to raid5_end_write_request?
>
> I like adding explanatory notes ... but I'm not quite sure what you a=
re
> suggesting here. =A0Could you be a little more explicit? =A0Thanks.
>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 59f5b05..8074515 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1758,7 +1758,8 @@ static void raid5_end_write_request(struct bio
*bi, int error)
                                replacement =3D 1;
                        else
                                /* rdev was removed and 'replacement'
-                                * replaced it.
+                                * replaced it.  rdev is not removed
+                                * until all requests are finished.
                                 */
                                rdev =3D conf->disks[i].rdev;
                        break;

>> 058c478..678a66d
>> raid10 and raid1 patches not reviewed.
>
> That's what a Christmas break is for, isn't it??

True, maybe that's my "wish I could find the time to do more code
review" wish coming true :-).

> Thanks for all the review - I really appreciate it.
>

Anytime.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
