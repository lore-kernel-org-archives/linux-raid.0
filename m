Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CAEC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 22:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiFHWHY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 18:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiFHWHY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 18:07:24 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3834837F04A;
        Wed,  8 Jun 2022 15:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=LufXSXEBmZFLcq4AsIpzM6cI1Bf+LCdEeFyP6I+AHkw=; b=ICdf9Du9tUtQzPKwgSsmL8vHLG
        YFRVGamfWS+YrCigjB+QuA8nU+dc7GXAz+sfR0wNDc6xRGbVbMFpnZyEpfxIcd83UOXSQ1b894DFH
        31vgzKNwGlHeo4+lfedPT5QXoNQ9iviOXsREFHgtCc0QnvPjkyd794LTvwfnlmUzOclYeCawKo2pb
        /j+D8KbXZn1cLIWi/5VGnXRQCjnmvbXev1AgIy8FS3/pXOs8bf+HO3jM7bUvGa3+aB8+2vJ/gnHQ7
        WW9DylHS/P/EtaWgkxJtksC0aCQAj4SA6FxvQU5PxQtbAoisUImUtnSdKjphaO0ZaMQ4xCK/D1RI/
        1BgWSGUg==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nz3pd-002CqB-CJ; Wed, 08 Jun 2022 16:07:19 -0600
Message-ID: <992ba80d-cc26-08bb-51eb-14f6cc6b126b@deltatee.com>
Date:   Wed, 8 Jun 2022 16:07:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220608162756.144600-1-logang@deltatee.com>
 <20220608162756.144600-5-logang@deltatee.com>
 <CAPhsuW6-kt+MvmaT_5aii7bnJ8N352S30Gr6wVoP4xjP20-GiQ@mail.gmail.com>
 <08b80caa-d726-b9f3-7ce0-f486b8080ec5@deltatee.com>
 <CAPhsuW4nx_WAtAibZJ3s8pNy+rxKsRKsLE-NL3tuDuwoC5BaXw@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPhsuW4nx_WAtAibZJ3s8pNy+rxKsRKsLE-NL3tuDuwoC5BaXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: song@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, hch@lst.de
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v4 04/11] md/raid5: Ensure array is suspended for calls to
 log_exit()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-06-08 16:02, Song Liu wrote:
> On Wed, Jun 8, 2022 at 11:21 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>>
>>
>>
>> On 2022-06-08 11:59, Song Liu wrote:
>>> On Wed, Jun 8, 2022 at 9:28 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>>>>
>>>> The raid5-cache code relies on there being no IO in flight when
>>>> log_exit() is called. There are two places where this is not
>>>> guaranteed so add mddev_suspend() and mddev_resume() calls to these
>>>> sites.
>>>>
>>>> The site in raid5_remove_disk() has a comment saying that it is
>>>> called in raid5d and thus cannot wait for pending writes; however that
>>>> does not appear to be correct anymore (if it ever was) as
>>>> raid5_remove_disk() is called from hot_remove_disk() which only
>>>> appears to be called in the md_ioctl(). Thus, the comment is removed,
>>>> as well as the racy check and replaced with calls to suspend/resume.
>>>>
>>>> The site in raid5_change_consistency_policy() is in the error path,
>>>> and another similar call site already has suspend/resume calls just
>>>> below it; so it should be equally safe to make that change here.
>>>>
>>>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> ---
>>>>  drivers/md/raid5.c | 18 ++++++------------
>>>>  1 file changed, 6 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> index 5d09256d7f81..3ad37dd4c5cd 100644
>>>> --- a/drivers/md/raid5.c
>>>> +++ b/drivers/md/raid5.c
>>>> @@ -7938,18 +7938,9 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>>>>
>>>>         print_raid5_conf(conf);
>>>>         if (test_bit(Journal, &rdev->flags) && conf->log) {
>>>> -               /*
>>>> -                * we can't wait pending write here, as this is called in
>>>> -                * raid5d, wait will deadlock.
>>>> -                * neilb: there is no locking about new writes here,
>>>> -                * so this cannot be safe.
>>>> -                */
>>>> -               if (atomic_read(&conf->active_stripes) ||
>>>> -                   atomic_read(&conf->r5c_cached_full_stripes) ||
>>>> -                   atomic_read(&conf->r5c_cached_partial_stripes)) {
>>>> -                       return -EBUSY;
>>>> -               }
>>>> +               mddev_suspend(mddev);
>>>
>>> Unfortunately, the comment about deadlock is still true, and we cannot call
>>> mddev_suspend here. To trigger it:
>>
>> Ah, yes. What a tangle. I think we can just drop this patch. Now that we
>> are removing RCU it isn't actually necessary to fix the bug I was
>> seeing. It's still probably broken as the comment notes though.
> 
> How about we keep the suspend/resume in raid5_change_consistency_policy()?
> Like the one I just pushed to md-next:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=ac1506992459fe45a085c1f93df74d51c381887b

I'm good with that. Thanks.

I'll do some testing on md-next shortly.

Thanks,

Logan
