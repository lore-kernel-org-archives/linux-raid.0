Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71734C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 11:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F3861074
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 11:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhJRLyY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 07:54:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:46757 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhJRLyX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Oct 2021 07:54:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="215395567"
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="215395567"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 04:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="661346950"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 18 Oct 2021 04:52:12 -0700
Received: from [10.249.147.163] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.147.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 712C25809E4;
        Mon, 18 Oct 2021 04:52:11 -0700 (PDT)
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, Nigel Croxon <ncroxon@redhat.com>,
        Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1634289920-5037-1-git-send-email-xni@redhat.com>
 <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com>
 <CALTww28pOiSBMA3ozM+CpM2E4mNFf2kpfGO5o3zN1oEu21tYCw@mail.gmail.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <34bc33db-101f-9306-01fe-6d6dde23a695@linux.intel.com>
Date:   Mon, 18 Oct 2021 13:52:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CALTww28pOiSBMA3ozM+CpM2E4mNFf2kpfGO5o3zN1oEu21tYCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18.10.2021 11:58, Xiao Ni wrote:
>>> The test case is:
>>> 1. create one imsm container
>>> 2. create a raid5 device from the container
>>> 3. unplug two disks
>>> 4. mdadm --detail /dev/md126
>>> [root@rhel85 ~]# mdadm -D /dev/md126
>>> /dev/md126:
>>>            Container : ��, member 0
>>>
>>> The Detail function first gets container name by function
>>> map_dev_preferred. Then it tries to find which disks are
>>> available. In patch db5377883fef(It should be FAILED..)
>>> uses map_dev_preferred to find which disks are under /dev.
>>>
>>> But now, the major/minor information comes from kernel space.
>>> map_dev_preferred malloc memory and init a device list when
>>> first be called by Detail. It can't find the device in the
>>> list by the major/minor. It free the memory and reinit the
>>> list.
>>>   > The container name now points to an area tha has been freed.
>>> So the containt is a mess.
>>>
>>
>> Container name is collected with 'create' flag set, so it's
>> name is additionally copied to static memory to prevent
>> overwrites. Could you verify?
> 
> Hi Mariusz
> 
> The chapter above you mentioned is talking about the creation process?
> The container name mentioned from the patch is a temporary variable in
> Detail function.
> 
> You want to say we can use the container name from the "static memory" in
> Detail function, so we don't get the container name again? And where is the
> static memory?
> 

There is a code:
	if (create && !regular && !preferred) {
		static char buf[30]; <- this variable will survive retry.
		snprintf(buf, sizeof(buf), "%d:%d", major, minor);
		regular = buf;
	}
but seems that it is not a case for this scenario. I suspected that
this was used because when gathering container name:

		container = map_dev_preferred(major(devid), minor(devid),
					      1, c->prefer);

'create' is explicitly set to 1. That is why I expect to have 'container'
declared in static area. Make sense?


>>> This patch replaces map_dev_preferred with devid2kname. If
>>> the name is NULL, it means the disk is unplug.
>>>
>> Your patch fixes only one place. Please go forward and analyze all
>> map_dev_preffered() calls (which looks safe to me). Maybe this
>> function can be replaced at all and we can drop this code in
>> flavor of devid2kname() or other.
> 
> At first, I just wanted to fix this bug. We can check all the places which
> are using map_dev_preffered. But it looks like a big project. It needs to
> understand all codes related to this function. It needs more time. Do you
> agree with fixing this bug first, then we can try to fix the hidden bugs.
> 
Sure, we are in rc2, so bigger changes should be merged after release.
It need to wait for now. Seems to be good future improvement.

>>
>>> Fixes: db5377883fef (It should be FAILED when raid has)
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> Reported-by: Fine Fan <ffan@redhat.com>
>>> ---
>>>    Detail.c | 12 +++++++-----
>>>    1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/Detail.c b/Detail.c
>>> index d3af0ab..2164de3 100644
>>> --- a/Detail.c
>>> +++ b/Detail.c
>>> @@ -351,11 +351,13 @@ int Detail(char *dev, struct context *c)
>>>        avail = xcalloc(array.raid_disks, 1);
>>>
>>>        for (d = 0; d < array.raid_disks; d++) {
>>> -             char *dv, *dv_rep;
>>> -             dv = map_dev_preferred(disks[d*2].major,
>>> -                             disks[d*2].minor, 0, c->prefer);
>>> -             dv_rep = map_dev_preferred(disks[d*2+1].major,
>>> -                             disks[d*2+1].minor, 0, c->prefer);
>>> +             char *dv, *dv_rep = NULL;
>>> +
>>> +             if (!disks[d*2].major && !disks[d*2].minor)
>>> +                     continue; > +
>>> +             dv = devid2kname(makedev(disks[d*2].major, disks[d*2].minor));
>>> +             dv_rep = devid2kname(makedev(disks[d*2+1].major, disks[d*2+1].minor));
>>>
>>>                if ((dv && (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
>>>                    (dv_rep && (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
>>>
>>
>> Yeah, I know that it is used in Detail this way, but please  determine
>> way to replace this ugly [d*2] and [d*2+1].
> 
> Yes, it takes me much time to understand how to calculate avail[]. We
> can focus on
> fixing this bug first, then we prepare some patches for improving the codes that
> related to the function map_dev_preferred and the [d*2] format codes.
> It might be
> a big change.
> 
Agree.

>>
>> This whole block should be moved from Detail() code to separate
>> function, which determines if device or replacement is in sync.
> 
> A good suggestion. Put it into the change I mentioned above, is it ok?
> 
Agree. So, will you take care about all improvements later (after release)?

Thanks,
Mariusz
