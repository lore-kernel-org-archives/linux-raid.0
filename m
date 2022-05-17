Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF4DC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 17 May 2022 08:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbiEQIRe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 May 2022 04:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240401AbiEQIRX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 May 2022 04:17:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482339FD6
        for <linux-raid@vger.kernel.org>; Tue, 17 May 2022 01:16:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0711B1FBB4;
        Tue, 17 May 2022 08:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652775382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zD6CwSNRAHLQmM2Se0YOpyzwqV+8ghcWR7LuNmCWRFM=;
        b=MIRVwTaAji2r0s/Jb2+G9zLmU4CG6bIKnr40kCRJAFXEypsLQJHs4kVpxM60njJjESMF9q
        5xqG3YVIhILulQxKe0kSahk8vHBzcJ1mUdPPuq7Wsn+TvPEvLQ5YtK8rNMGPzaZcM8dra8
        n/F55/FyK39tXXi/zFb1Qqeug4xSNbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652775382;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zD6CwSNRAHLQmM2Se0YOpyzwqV+8ghcWR7LuNmCWRFM=;
        b=D2xUNdRmdy3rGiZ8ukNgcBIbhzCheHT5tnhBP407IOy+uAa+r2+63bWUaytzLu9gwCXt9r
        FwCvTrPAezyIfuCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CEAB713305;
        Tue, 17 May 2022 08:16:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I7eqJtRZg2ImDgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 17 May 2022 08:16:20 +0000
Message-ID: <50b18e73-7ac0-a37a-6280-7e827c1c0952@suse.de>
Date:   Tue, 17 May 2022 16:16:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: =?UTF-8?B?UmU6IOWbnuWkje+8mm1kYWRtIHRlc3Qgc3VpdGUgaW1wcm92ZW1lbnRz?=
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Xiao Ni <xni@redhat.com>, Nigel Croxon <ncroxon@redhat.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220516160941.00004e83@linux.intel.com>
 <CALTww2-mbfZRcHu_95Q+WANXZ9ayRwjXvyvqP5Gseeb86dEy=w@mail.gmail.com>
 <-laavsfgtlo10lebdsj460ptakf7ob3swf0up-4xyanlxfob29oebwn0um9140l133r8-rukduq-tekz50-og1qjp-za66of-qnod9a-cdghzt8enrbc-ei4sg9-7sa12trdyicp-e03x62jcjj2j-h0xih6.1652752832458@email.android.com>
 <20220517095419.00004b30@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220517095419.00004b30@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/17/22 3:54 PM, Mariusz Tkaczyk wrote:
> Hi,
> I wanted to add it to the mdadm repo, let say under directory
> "python_tests". I didn't started work yet. Those tests should stay with mdadm,
> so we can develop them with Coly using mdadm-ci and later ask Jes to merge the
> branch.

I am fine and supportive to this idea. mdadm-tests is from the ci 
testing itself, I can copy python_tests to it time to time.

>
> I don't have any details, I just asked to gather feedback. Seems that there is
> big interest in this change. If there is any volunteer to take this topic and
> prepare python API for testing and first tests- I will be pleased to help.
>
> I could take long time before I will start this topic.


Let's wait for response. If no one response for a while, then the person 
should be me LOL. I am learning Python now, and the progress might take 
time anyway.


Thanks.


Coly Li


>
> Thanks,
> Mariusz
>
> On Tue, 17 May 2022 10:00:32 +0800
> ‪Coly Li‬ <colyli@suse.de> wrote:
>
>> Hi Xiao,
>>
>> Yes there is a git repo specific for test scripts, to test the mdadm-ci repo.
>> It is located on kernel.org git server, which currently only contains bash
>> scripts copied from mdadm.
>>
>> Coly
>>
>>  From my phone
>>
>>
>>
>> -------- 原始邮件 --------
>> 发件人： Xiao Ni <xni@redhat.com>
>> 日期： 2022年5月17日周二 上午9:48
>> 收件人： Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>> 抄送： Nigel Croxon <ncroxon@redhat.com>, Coly Li <colyli@suse.de>, Jes
>> Sorensen <jes@trained-monkey.org>, linux-raid <linux-raid@vger.kernel.org> 主
>> 题： Re: mdadm test suite improvements Hi Mariusz
>>> Thanks for the effort. Have you init the git project to start this? If
>>> so, you can send it, so we can
>>> work together about this.
>>>
>>> Best Regards
>>> Xiao
>>>
>>> On Mon, May 16, 2022 at 10:09 PM Mariusz Tkaczyk
>>> <mariusz.tkaczyk@linux.intel.com> wrote:
>>>> Hello All,
>>>> I'm working on names handling in mdadm and I need to add some new test to
>>>> the mdadm scope - to verify that it is working as desired.
>>>> Bash is not best choice for testing and in current form, our tests are not
>>>> friendly for developers. I would like to introduce another python based
>>>> test scope and add it to repository. I will integrate it with current
>>>> framework.
>>>>
>>>> I can see that currently test are not well used and they aren't often
>>>> updated. I want to bring new life to them. Adopting more modern approach
>>>> seems to be good start point.
>>>> Any thoughts?
>>>>
>>>> Thanks in advance,
>>>> Mariusz
>>>>
>>>

