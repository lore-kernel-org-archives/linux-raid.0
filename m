Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB503ECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 12:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiIUMOF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 08:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiIUMOE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 08:14:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9EA956A7
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 05:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663762441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VUzQ8BEwQcFWd2hBEO+7yHHe4skgjIJlFW134JKk4TA=;
        b=Ew9qgonly7iNBfCJnc+umnyuaFPPh5iXR0ZhscAlyI/1dpTAXj+v1p/88fa7O8UA9ZXTI0
        zT/LITltxusoRDxmNCoqnCIjukbwWtBCGoTmps10UwXKNmUPM0LeMTVR7aoKBvQz37wA39
        FqylwchaJi91EFU7+cgC31SAUAna1Hc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-53-D_HjBsd4PQKXmGqH6NKrhg-1; Wed, 21 Sep 2022 08:14:00 -0400
X-MC-Unique: D_HjBsd4PQKXmGqH6NKrhg-1
Received: by mail-pj1-f71.google.com with SMTP id ev16-20020a17090aead000b00202cf672e74so3216069pjb.2
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 05:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VUzQ8BEwQcFWd2hBEO+7yHHe4skgjIJlFW134JKk4TA=;
        b=bGaz0nBUeKtr2Ysh8O7PYV/OZITmjxMHiNL4b5B+LDVieiCKrCRfU2o4yvgpNgvg9C
         U5a0JwN064oWdRQQOMNF11BqtZpv33g+KFGN+fKziKHkWZttToAsn5JUFE+BXwMSg2x/
         wS8Zg17i6mUtBll5P/YBukDe3HylSorvLT+Ot08RwNINIUBQv5uvBse460TPsYUJRQn4
         vQqDIT2Mloo8lLFzDVqfkcndKJ/AX9BO/iC03rfdq6Gy/neUqpkATIcuz5j8Dsj0AgfA
         tkE5c9pRCc+oLfr1+R/xgfITrA4Svz3g0wUIS+BCXstU37tohLv1N4mi4dfWBo4/rmtB
         zMzw==
X-Gm-Message-State: ACrzQf2bYmp2sPbGii6XaAJBNOWcfgt0oI1yEVnzDK2gV8G/ALfsEliS
        L2so2hmXowpCH301uaZkL5D4RFoP+s0T65HQrBYg8HvqJ/7j8cktM3LS/7IqPg0pCNduTCRmQy4
        IFfFCToF7WrvM8hBGXPxdC1ns1YrEMhOXcHsb4w==
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id b12-20020a056a00114c00b005282c7a6302mr28491926pfm.37.1663762428300;
        Wed, 21 Sep 2022 05:13:48 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7juZ0FvQPS19nbqpEsEqRUOtg8jI0fJ1ew9M66ajlRtDOSGNWORTCOMH00lQQPCWh7ajLt8vs9+e5lmJrFY74=
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id
 b12-20020a056a00114c00b005282c7a6302mr28491876pfm.37.1663762427745; Wed, 21
 Sep 2022 05:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220721121152.4180-1-colyli@suse.de> <20220721121152.4180-3-colyli@suse.de>
In-Reply-To: <20220721121152.4180-3-colyli@suse.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 21 Sep 2022 20:13:36 +0800
Message-ID: <CALTww2-Y6b+Ruqsux9e2gXSngzGioTwENAFsygj5Rbgipgy0wg@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] badblocks: add helper routines for badblock ranges handling
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-raid <linux-raid@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>,
        Vishal L Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly

Sorry for the late response and thanks for your patch.

On Thu, Jul 21, 2022 at 8:12 PM Coly Li <colyli@suse.de> wrote:
>
> This patch adds several helper routines to improve badblock ranges
> handling. These helper routines will be used later in the improved
> version of badblocks_set()/badblocks_clear()/badblocks_check().
>
> - Helpers prev_by_hint() and prev_badblocks() are used to find the bad
>   range from bad table which the searching range starts at or after.
>
> - The following helpers are to decide the relative layout between the
>   manipulating range and existing bad block range from bad table.
>   - can_merge_behind()
>     Return 'true' if the manipulating range can backward merge with the
>     bad block range.
>   - can_merge_front()
>     Return 'true' if the manipulating range can forward merge with the
>     bad block range.
>   - can_combine_front()
>     Return 'true' if two adjacent bad block ranges before the
>     manipulating range can be merged.
>   - overlap_front()
>     Return 'true' if the manipulating range exactly overlaps with the
>     bad block range in front of its range.
>   - overlap_behind()
>     Return 'true' if the manipulating range exactly overlaps with the
>     bad block range behind its range.
>   - can_front_overwrite()
>     Return 'true' if the manipulating range can forward overwrite the
>     bad block range in front of its range.
>
> - The following helpers are to add the manipulating range into the bad
>   block table. Different routine is called with the specific relative
>   layout between the manipulating range and other bad block range in the
>   bad block table.
>   - behind_merge()
>     Merge the manipulating range with the bad block range behind its
>     range, and return the number of merged length in unit of sector.
>   - front_merge()
>     Merge the manipulating range with the bad block range in front of
>     its range, and return the number of merged length in unit of sector.
>   - front_combine()
>     Combine the two adjacent bad block ranges before the manipulating
>     range into a larger one.

Is it good to add behind_combine here?

>   - front_overwrite()
>     Overwrite partial of whole bad block range which is in front of the
>     manipulating range. The overwrite may split existing bad block range
>     and generate more bad block ranges into the bad block table.
>   - insert_at()
>     Insert the manipulating range at a specific location in the bad
>     block table.
>
> All the above helpers are used in later patches to improve the bad block
> ranges handling for badblocks_set()/badblocks_clear()/badblocks_check().
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> ---
>  block/badblocks.c | 377 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 377 insertions(+)
>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 3afb550c0f7b..72be83507977 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -16,6 +16,383 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>
> +/*
> + * Find the range starts at-or-before 's' from bad table. The search
> + * starts from index 'hint' and stops at index 'hint_end' from the bad
> + * table.
> + */
> +static int prev_by_hint(struct badblocks *bb, sector_t s, int hint)
> +{
> +       int hint_end = hint + 2;
> +       u64 *p = bb->page;
> +       int ret = -1;
> +
> +       while ((hint < hint_end) && ((hint + 1) <= bb->count) &&
> +              (BB_OFFSET(p[hint]) <= s)) {
> +               if ((hint + 1) == bb->count || BB_OFFSET(p[hint + 1]) > s) {
> +                       ret = hint;
> +                       break;
> +               }
> +               hint++;
> +       }
> +
> +       return ret;
> +}
> +
> +/*
> + * Find the range starts at-or-before bad->start. If 'hint' is provided
> + * (hint >= 0) then search in the bad table from hint firstly. It is
> + * very probably the wanted bad range can be found from the hint index,
> + * then the unnecessary while-loop iteration can be avoided.
> + */
> +static int prev_badblocks(struct badblocks *bb, struct badblocks_context *bad,
> +                         int hint)
> +{
> +       sector_t s = bad->start;
> +       int ret = -1;
> +       int lo, hi;
> +       u64 *p;
> +
> +       if (!bb->count)
> +               goto out;
> +
> +       if (hint >= 0) {
> +               ret = prev_by_hint(bb, s, hint);
> +               if (ret >= 0)
> +                       goto out;
> +       }
> +
> +       lo = 0;
> +       hi = bb->count;
> +       p = bb->page;

Is it better to check something like this:

if (BB_OFFSET(p[lo]) > s)
   return ret;

> +
> +       while (hi - lo > 1) {
> +               int mid = (lo + hi)/2;
> +               sector_t a = BB_OFFSET(p[mid]);
> +
> +               if (a == s) {
> +                       ret = mid;
> +                       goto out;
> +               }
> +
> +               if (a < s)
> +                       lo = mid;
> +               else
> +                       hi = mid;
> +       }
> +
> +       if (BB_OFFSET(p[lo]) <= s)
> +               ret = lo;
> +out:
> +       return ret;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be backward merged
> + * with the bad range (from the bad table) index by 'behind'.
> + */
> +static bool can_merge_behind(struct badblocks *bb, struct badblocks_context *bad,
> +                            int behind)
> +{
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +
> +       if ((s < BB_OFFSET(p[behind])) &&
> +           ((s + sectors) >= BB_OFFSET(p[behind])) &&
> +           ((BB_END(p[behind]) - s) <= BB_MAX_LEN) &&
> +           BB_ACK(p[behind]) == bad->ack)
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Do backward merge for range indicated by 'bad' and the bad range
> + * (from the bad table) indexed by 'behind'. The return value is merged
> + * sectors from bad->len.
> + */
> +static int behind_merge(struct badblocks *bb, struct badblocks_context *bad,
> +                       int behind)
> +{
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +       int merged = 0;
> +
> +       WARN_ON(s >= BB_OFFSET(p[behind]));
> +       WARN_ON((s + sectors) < BB_OFFSET(p[behind]));
> +
> +       if (s < BB_OFFSET(p[behind])) {
> +               merged = BB_OFFSET(p[behind]) - s;
> +               p[behind] =  BB_MAKE(s, BB_LEN(p[behind]) + merged, bad->ack);
> +
> +               WARN_ON((BB_LEN(p[behind]) + merged) >= BB_MAX_LEN);
> +       }
> +
> +       return merged;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can be forward
> + * merged with the bad range (from the bad table) indexed by 'prev'.
> + */
> +static bool can_merge_front(struct badblocks *bb, int prev,
> +                           struct badblocks_context *bad)
> +{
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +
> +       if (BB_ACK(p[prev]) == bad->ack &&
> +           (s < BB_END(p[prev]) ||
> +            (s == BB_END(p[prev]) && (BB_LEN(p[prev]) < BB_MAX_LEN))))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Do forward merge for range indicated by 'bad' and the bad range
> + * (from bad table) indexed by 'prev'. The return value is sectors
> + * merged from bad->len.
> + */
> +static int front_merge(struct badblocks *bb, int prev, struct badblocks_context *bad)
> +{
> +       sector_t sectors = bad->len;
> +       sector_t s = bad->start;
> +       u64 *p = bb->page;
> +       int merged = 0;
> +
> +       WARN_ON(s > BB_END(p[prev]));
> +
> +       if (s < BB_END(p[prev])) {
> +               merged = min_t(sector_t, sectors, BB_END(p[prev]) - s);
> +       } else {
> +               merged = min_t(sector_t, sectors, BB_MAX_LEN - BB_LEN(p[prev]));
> +               if ((prev + 1) < bb->count &&
> +                   merged > (BB_OFFSET(p[prev + 1]) - BB_END(p[prev]))) {
> +                       merged = BB_OFFSET(p[prev + 1]) - BB_END(p[prev]);
> +               }
> +
> +               p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +                                 BB_LEN(p[prev]) + merged, bad->ack);
> +       }
> +
> +       return merged;
> +}
> +
> +/*
> + * 'Combine' is a special case which can_merge_front() is not able to
> + * handle: If a bad range (indexed by 'prev' from bad table) exactly
> + * starts as bad->start, and the bad range ahead of 'prev' (indexed by
> + * 'prev - 1' from bad table) exactly ends at where 'prev' starts, and
> + * the sum of their lengths does not exceed BB_MAX_LEN limitation, then
> + * these two bad range (from bad table) can be combined.
> + *
> + * Return 'true' if bad ranges indexed by 'prev' and 'prev - 1' from bad
> + * table can be combined.
> + */
> +static bool can_combine_front(struct badblocks *bb, int prev,
> +                             struct badblocks_context *bad)
> +{
> +       u64 *p = bb->page;
> +
> +       if ((prev > 0) &&
> +           (BB_OFFSET(p[prev]) == bad->start) &&
> +           (BB_END(p[prev - 1]) == BB_OFFSET(p[prev])) &&
> +           (BB_LEN(p[prev - 1]) + BB_LEN(p[prev]) <= BB_MAX_LEN) &&
> +           (BB_ACK(p[prev - 1]) == BB_ACK(p[prev])))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Combine the bad ranges indexed by 'prev' and 'prev - 1' (from bad
> + * table) into one larger bad range, and the new range is indexed by
> + * 'prev - 1'.
> + */
> +static void front_combine(struct badblocks *bb, int prev)
> +{
> +       u64 *p = bb->page;
> +
> +       p[prev - 1] = BB_MAKE(BB_OFFSET(p[prev - 1]),
> +                             BB_LEN(p[prev - 1]) + BB_LEN(p[prev]),
> +                             BB_ACK(p[prev]));
> +       if ((prev + 1) < bb->count)
> +               memmove(p + prev, p + prev + 1, (bb->count - prev - 1) * 8);
            else
                    p[prev] = 0;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly forward
> + * overlapped with the bad range (from bad table) indexed by 'front'.
> + * Exactly forward overlap means the bad range (from bad table) indexed
> + * by 'prev' does not cover the whole range indicated by 'bad'.
> + */
> +static bool overlap_front(struct badblocks *bb, int front,
> +                         struct badblocks_context *bad)
> +{
> +       u64 *p = bb->page;
> +
> +       if (bad->start >= BB_OFFSET(p[front]) &&
> +           bad->start < BB_END(p[front]))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly backward
> + * overlapped with the bad range (from bad table) indexed by 'behind'.
> + */
> +static bool overlap_behind(struct badblocks *bb, struct badblocks_context *bad,
> +                          int behind)
> +{
> +       u64 *p = bb->page;
> +
> +       if (bad->start < BB_OFFSET(p[behind]) &&
> +           (bad->start + bad->len) > BB_OFFSET(p[behind]))
> +               return true;
> +       return false;
> +}
> +
> +/*
> + * Return 'true' if the range indicated by 'bad' can overwrite the bad
> + * range (from bad table) indexed by 'prev'.
> + *
> + * The range indicated by 'bad' can overwrite the bad range indexed by
> + * 'prev' when,
> + * 1) The whole range indicated by 'bad' can cover partial or whole bad
> + *    range (from bad table) indexed by 'prev'.
> + * 2) The ack value of 'bad' is larger or equal to the ack value of bad
> + *    range 'prev'.

In fact, it can overwrite only the ack value of 'bad' is larger than
the ack value of the bad range 'prev'.
If the ack values are equal, it should do a merge operation.

> + *
> + * If the overwriting doesn't cover the whole bad range (from bad table)
> + * indexed by 'prev', new range might be split from existing bad range,
> + * 1) The overwrite covers head or tail part of existing bad range, 1
> + *    extra bad range will be split and added into the bad table.
> + * 2) The overwrite covers middle of existing bad range, 2 extra bad
> + *    ranges will be split (ahead and after the overwritten range) and
> + *    added into the bad table.
> + * The number of extra split ranges of the overwriting is stored in
> + * 'extra' and returned for the caller.
> + */
> +static bool can_front_overwrite(struct badblocks *bb, int prev,
> +                               struct badblocks_context *bad, int *extra)
> +{
> +       u64 *p = bb->page;
> +       int len;
> +
> +       WARN_ON(!overlap_front(bb, prev, bad));
> +
> +       if (BB_ACK(p[prev]) >= bad->ack)
> +               return false;
> +
> +       if (BB_END(p[prev]) <= (bad->start + bad->len)) {
> +               len = BB_END(p[prev]) - bad->start;
> +               if (BB_OFFSET(p[prev]) == bad->start)
> +                       *extra = 0;
> +               else
> +                       *extra = 1;
> +
> +               bad->len = len;
> +       } else {
> +               if (BB_OFFSET(p[prev]) == bad->start)
> +                       *extra = 1;
> +               else
> +               /*
> +                * prev range will be split into two, beside the overwritten
> +                * one, an extra slot needed from bad table.
> +                */
> +                       *extra = 2;
> +       }
> +
> +       if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
> +               return false;
> +
> +       return true;
> +}
> +
> +/*
> + * Do the overwrite from the range indicated by 'bad' to the bad range
> + * (from bad table) indexed by 'prev'.
> + * The previously called can_front_overwrite() will provide how many
> + * extra bad range(s) might be split and added into the bad table. All
> + * the splitting cases in the bad table will be handled here.
> + */
> +static int front_overwrite(struct badblocks *bb, int prev,
> +                          struct badblocks_context *bad, int extra)
> +{
> +       u64 *p = bb->page;
> +       sector_t orig_end = BB_END(p[prev]);
> +       int orig_ack = BB_ACK(p[prev]);
> +
> +       switch (extra) {
> +       case 0:
> +               p[prev] = BB_MAKE(BB_OFFSET(p[prev]), BB_LEN(p[prev]),
> +                                 bad->ack);
> +               break;
> +       case 1:
> +               if (BB_OFFSET(p[prev]) == bad->start) {
> +                       p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +                                         bad->len, bad->ack);
> +                       memmove(p + prev + 2, p + prev + 1,
> +                               (bb->count - prev - 1) * 8);
> +                       p[prev + 1] = BB_MAKE(bad->start + bad->len,
> +                                             orig_end - BB_END(p[prev]),
> +                                             orig_ack);
> +               } else {
> +                       p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +                                         bad->start - BB_OFFSET(p[prev]),
> +                                         BB_ACK(p[prev]));

s/BB_ACK(p[prev])/orig_ack/g
> +                       /*
> +                        * prev +2 -> prev + 1 + 1, which is for,
> +                        * 1) prev + 1: the slot index of the previous one
> +                        * 2) + 1: one more slot for extra being 1.
> +                        */
> +                       memmove(p + prev + 2, p + prev + 1,
> +                               (bb->count - prev - 1) * 8);
> +                       p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
> +               }
> +               break;
> +       case 2:
> +               p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +                                 bad->start - BB_OFFSET(p[prev]),
> +                                 BB_ACK(p[prev]));

s/BB_ACK(p[prev])/orig_ack/g

> +               /*
> +                * prev + 3 -> prev + 1 + 2, which is for,
> +                * 1) prev + 1: the slot index of the previous one
> +                * 2) + 2: two more slots for extra being 2.
> +                */
> +               memmove(p + prev + 3, p + prev + 1,
> +                       (bb->count - prev - 1) * 8);
> +               p[prev + 1] = BB_MAKE(bad->start, bad->len, bad->ack);
> +               p[prev + 2] = BB_MAKE(BB_END(p[prev + 1]),
> +                                     orig_end - BB_END(p[prev + 1]),
> +                                     BB_ACK(p[prev]));

s/BB_ACK(p[prev])/orig_ack/g
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return bad->len;
> +}
> +
> +/*
> + * Explicitly insert a range indicated by 'bad' to the bad table, where
> + * the location is indexed by 'at'.
> + */
> +static int insert_at(struct badblocks *bb, int at, struct badblocks_context *bad)
> +{
> +       u64 *p = bb->page;
> +       int len;
> +
> +       WARN_ON(badblocks_full(bb));
> +
> +       len = min_t(sector_t, bad->len, BB_MAX_LEN);
> +       if (at < bb->count)
> +               memmove(p + at + 1, p + at, (bb->count - at) * 8);
> +       p[at] = BB_MAKE(bad->start, len, bad->ack);
> +
> +       return len;
> +}
> +
>  /**
>   * badblocks_check() - check a given range for bad sectors
>   * @bb:                the badblocks structure that holds all badblock information
> --
> 2.35.3
>

Regards

Xiao

