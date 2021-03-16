Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0375AC43381
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 07:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D982D65080
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 07:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhCPHCe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 03:02:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:15381 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234030AbhCPHCP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Mar 2021 03:02:15 -0400
IronPort-SDR: 4MBLHORUFxQcnWWr6TpC7V4gkSIDpUVPOgdEJLIByhzMx4yfLa5VsqtSiP1pKy0sGhw/fevbS2
 0L+h9ivy9dDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="209140083"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="209140083"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:02:15 -0700
IronPort-SDR: aV1xAFKK9DXT+lqu270bLksjaJDIfkwZStEPPhtfjG5njKz8VRxfRbMuzBc/yXdM0UtwuF0/Oh
 uIl0WHYnpCoQ==
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="388369215"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.11]) ([10.239.13.11])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 00:02:13 -0700
Subject: Re: [kbuild-all] Re: [song-md:md-next 5/6]
 drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before object
 free at line 1532.
To:     Song Liu <songliubraving@fb.com>, Xiao Ni <xni@redhat.com>
Cc:     kernel test robot <lkp@intel.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <202103160841.GSRvizC4-lkp@intel.com>
 <dda31d3a-3424-6eb3-4f36-e715affc7015@redhat.com>
 <3EE962E0-8054-4460-8EEB-0338EE5C1940@fb.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <85f3998d-82a8-095a-951d-04c141e0beef@intel.com>
Date:   Tue, 16 Mar 2021 15:01:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3EE962E0-8054-4460-8EEB-0338EE5C1940@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/16/21 2:56 PM, Song Liu wrote:
>
>> On Mar 15, 2021, at 7:29 PM, Xiao Ni <xni@redhat.com> wrote:
>>
>> Hi all
>>
>> The atomic_t r10_bio->remaining starts at 1 in raid10_handle_discard. It means
>> raid10_handle_discard uses it and sets it to 1. So in fact it starts at 0 and sets to 1
>> when it's used at first time. Then r10_bio->remaining is added by atomic_inc per usage.
>>
>> It decrements the value when leaving raid10_handle_discard and in every callback function.
>> So the count of r10_bio->remaining in this patch is right.
>>
>> Regards
>> Xiao
> It does look like a false alarm, as we set r10bio to first_r10bio after
> the free.
>
> Thanks,
> Song

Hi all,

Thanks for the clarification, we have disabled such warning.

Best Regards,
Rong Chen

>
>> On 03/16/2021 08:29 AM, kernel test robot wrote:
>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
>>> head:   49c4d345c81f149a29b3db6e521e5191e55f02b6
>>> commit: f3cf8c2b2caf6ae77b7c786218d3b060faef63a6 [5/6] md/raid10: improve discard request for far layout
>>> config: x86_64-allyesconfig (attached as .config)
>>> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>>>
>>> If you fix the issue, kindly add following tag as appropriate
>>> Reported-by: kernel test robot <lkp@intel.com>
>>>
>>>
>>> "coccinelle warnings: (new ones prefixed by >>)"
>>>>> drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before object free at line 1532.
>>>     drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before object free at line 1537.
>>>
>>> vim +1526 drivers/md/raid10.c
>>>
>>>    1520	
>>>    1521	static void raid_end_discard_bio(struct r10bio *r10bio)
>>>    1522	{
>>>    1523		struct r10conf *conf = r10bio->mddev->private;
>>>    1524		struct r10bio *first_r10bio;
>>>    1525	
>>>> 1526		while (atomic_dec_and_test(&r10bio->remaining)) {
>>>    1527	
>>>    1528			allow_barrier(conf);
>>>    1529	
>>>    1530			if (!test_bit(R10BIO_Discard, &r10bio->state)) {
>>>    1531				first_r10bio = (struct r10bio *)r10bio->master_bio;
>>>> 1532				free_r10bio(r10bio);
>>>    1533				r10bio = first_r10bio;
>>>    1534			} else {
>>>    1535				md_write_end(r10bio->mddev);
>>>    1536				bio_endio(r10bio->master_bio);
>>>    1537				free_r10bio(r10bio);
>>>    1538				break;
>>>    1539			}
>>>    1540		}
>>>    1541	}
>>>    1542	
>>>
>>> ---
>>> 0-DAY CI Kernel Test Service, Intel Corporation
>>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

