Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D48C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 07:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C655E2080C
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 07:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0/SPj7B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgHTH0z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 03:26:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbgHTH0y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 03:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597908412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+lrSvXLMlkFIk79vgyBx5WjbrO9jJufRoaoXVAYPxw=;
        b=V0/SPj7B7PA8R0vmgZkn20O9SjZNTBQOtH60DYnt4S/h28kunKOIEssLi2029VlX/O8s/g
        mUPHeBm1BIfCLHyC10PN7EC9CijbEE/OlwVMGo0d28KDYGHzJkIKHDmugJVabE7s/5hoLY
        KgFUnzsxiAsa0dQaO1Lp1hHBupAkTr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-JBPgo2oGM-qDY-k7MSIkTQ-1; Thu, 20 Aug 2020 03:26:50 -0400
X-MC-Unique: JBPgo2oGM-qDY-k7MSIkTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E62F1074643;
        Thu, 20 Aug 2020 07:26:49 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-35.pek2.redhat.com [10.72.8.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC92B5C88B;
        Thu, 20 Aug 2020 07:26:45 +0000 (UTC)
Subject: Re: [PATCH V3 3/4] md/raid10: improve raid10 discard request
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <1597306476-8396-1-git-send-email-xni@redhat.com>
 <1597306476-8396-4-git-send-email-xni@redhat.com>
 <CAPhsuW4sa8PBC8sn4u+9SBMEHkinoAr2jRss1bSsvV+WQ+yPuA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <f1a59821-cd64-d694-5d4e-f0dba81e635f@redhat.com>
Date:   Thu, 20 Aug 2020 15:26:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4sa8PBC8sn4u+9SBMEHkinoAr2jRss1bSsvV+WQ+yPuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song


On 08/20/2020 02:36 AM, Song Liu wrote:
> On Thu, Aug 13, 2020 at 1:15 AM Xiao Ni <xni@redhat.com> wrote:
> [...]
>> Reviewed-by: Coly Li <colyli@suse.de>
>> Reviewed-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>
> Please add "---" before "v1:..." so that this part is ignored during git am.
Ok
>
>> v1:
>> Coly helps to review these patches and give some suggestions:
>> One bug is found. If discard bio is across one stripe but bio size is bigger
>> than one stripe size. After spliting, the bio will be NULL. In this version,
>> it checks whether discard bio size is bigger than 2*stripe_size.
>> In raid10_end_discard_request, it's better to check R10BIO_Uptodate is set
>> or not. It can avoid write memory to improve performance.
>> Add more comments for calculating addresses.
>>
>> v2:
>> Fix error by checkpatch.pl
>> Fix one bug for offset layout. v1 calculates wrongly split size
>> Add more comments to explain how the discard range of each component disk
>> is decided.
>> ---
>>   drivers/md/raid10.c | 287 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 286 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index cef3cb8..5431e1b 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1526,6 +1526,287 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
>>                  raid10_write_request(mddev, bio, r10_bio);
>>   }
>>
>> +static void wait_blocked_dev(struct mddev *mddev, int cnt)
>> +{
>> +       int i;
>> +       struct r10conf *conf = mddev->private;
>> +       struct md_rdev *blocked_rdev = NULL;
>> +
>> +retry_wait:
>> +       rcu_read_lock();
>> +       for (i = 0; i < cnt; i++) {
>> +               struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
>> +               struct md_rdev *rrdev = rcu_dereference(
>> +                       conf->mirrors[i].replacement);
>> +               if (rdev == rrdev)
>> +                       rrdev = NULL;
>> +               if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
>> +                       atomic_inc(&rdev->nr_pending);
>> +                       blocked_rdev = rdev;
>> +                       break;
>> +               }
>> +               if (rrdev && unlikely(test_bit(Blocked, &rrdev->flags))) {
>> +                       atomic_inc(&rrdev->nr_pending);
>> +                       blocked_rdev = rrdev;
>> +                       break;
>> +               }
>> +       }
>> +       rcu_read_unlock();
>> +
>> +       if (unlikely(blocked_rdev)) {
>> +               /* Have to wait for this device to get unblocked, then retry */
>> +               allow_barrier(conf);
>> +               raid10_log(conf->mddev, "%s wait rdev %d blocked",
>> +                               __func__, blocked_rdev->raid_disk);
>> +               md_wait_for_blocked_rdev(blocked_rdev, mddev);
>> +               wait_barrier(conf);
>> +               goto retry_wait;
> We need to clear blocked_rdev before this goto, or put retry_wait label
> before "blocked_rdev = NULL;". I guess this path is not tested...
I did test for this patch with mkfs with/without resync and wrote some 
files to device.
And ran fstrim after writing some files. The patch worked well during 
the test.
For blocked device situation, I didn't test. I'll add this test.
>
> We are duplicating a lot of logic from raid10_write_request() here. Can we
> try to pull the common logic into a helper function?
I'll do this.
>
> [...]
>
>> +static void raid10_end_discard_request(struct bio *bio)
>> +{
>> +       struct r10bio *r10_bio = bio->bi_private;
>> +       struct r10conf *conf = r10_bio->mddev->private;
>> +       struct md_rdev *rdev = NULL;
>> +       int dev;
>> +       int slot, repl;
>> +
>> +       /*
>> +        * We don't care the return value of discard bio
>> +        */
>> +       if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>> +               set_bit(R10BIO_Uptodate, &r10_bio->state);
>> +
>> +       dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
>> +       if (repl)
>> +               rdev = conf->mirrors[dev].replacement;
>> +       if (!rdev) {
>> +               smp_rmb();
>> +               repl = 0;
>> +               rdev = conf->mirrors[dev].rdev;
>> +       }
>> +
>> +       if (atomic_dec_and_test(&r10_bio->remaining)) {
>> +               md_write_end(r10_bio->mddev);
>> +               raid_end_bio_io(r10_bio);
>> +       }
>> +
>> +       rdev_dec_pending(rdev, conf->mddev);
>> +}
>> +
>> +/* There are some limitations to handle discard bio
>> + * 1st, the discard size is bigger than stripe_size*2.
>> + * 2st, if the discard bio spans reshape progress, we use the old way to
>> + * handle discard bio
>> + */
>> +static bool raid10_handle_discard(struct mddev *mddev, struct bio *bio)
>> +{
>> +       struct r10conf *conf = mddev->private;
>> +       struct geom geo = conf->geo;
> Do we really need a full copy of conf->geo?
It doesn't need a full copy. Thanks for pointing about this.
>
>> +       struct r10bio *r10_bio;
>> +
>> +       int disk;
>> +       sector_t chunk;
>> +       int stripe_size, stripe_mask;
>> +
>> +       sector_t bio_start, bio_end;
>> +       sector_t first_stripe_index, last_stripe_index;
>> +       sector_t start_disk_offset;
>> +       unsigned int start_disk_index;
>> +       sector_t end_disk_offset;
>> +       unsigned int end_disk_index;
>> +
>> +       wait_barrier(conf);
>> +
>> +       if (conf->reshape_progress != MaxSector &&
>> +           ((bio->bi_iter.bi_sector >= conf->reshape_progress) !=
>> +            conf->mddev->reshape_backwards))
>> +               geo = conf->prev;
>> +
>> +       stripe_size = (1<<geo.chunk_shift) * geo.raid_disks;
> This could be raid_disks << chunk_shift
ok
>
>> +       stripe_mask = stripe_size - 1;
> Does this work when raid_disks is not power of 2?
In test I used 5 disks to create the raid10 too, it worked well. Could 
you explain what
you worried in detail?

Regards
Xiao

