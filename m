Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA298C4332F
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 09:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiLCJmR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 04:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiLCJmF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 04:42:05 -0500
Received: from cmx-alt-rgout001.mx-altice.prod.cloud.synchronoss.net (cmx-alt-rgout001.mx-altice.prod.cloud.synchronoss.net [65.20.48.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82D064576
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 01:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suddenlinkmail.com; s=dkim-001; t=1670060521; 
        bh=L3AswDV9YNK0Y1vd7T3QVpvB6eNOj4TfmoC3wqX03VE=;
        h=Message-ID:Date:MIME-Version:To:References:From:Subject:In-Reply-To:Content-Type;
        b=dmmaNPnogiKUy+kDi5v63w/3ySXPNnjNJ7xSHlddbOeDOD/VBiQjJ1bQpbGkKOs3r39OJBMe5Xkn2seMxzJdOxbzPKtxVfLR7CS8nEBgt9WPIlE0cjRMYq2XADYQ5clP5vIFDBMvhYUJf35uHI/CoHmgRF9DnHMkHJIF74O79q85XPale13VTKH6iJ+rpPe8Bh/giktT+9YuewVvSbBdIWRYvdXDA7M2d4kVsGRuDb1l8pVtnCzYvqcphLZggIzw9PMSpMoixZP+vhtfqp0dEr3He3igx/OYAOmuCLBnOV5alzuTChubjqBOggbfQDjRZC7zcQTbSwX3XddBcH8veg==
X-RG-VS-CS: clean
X-RG-VS-SC: 0
X-RG-VS: Clean
X-Originating-IP: [66.76.46.195]
X-RG-Env-Sender: drankinatty@suddenlinkmail.com
X-RG-Rigid: 636B531D0664B343
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvhedruddtgddtjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucetnffvkfevgfgfufdpggftfghnshhusghstghrihgsvgdpqfgfvfenuceurghilhhouhhtmecufedttdenucenucfjughrpefkffggfgfvfhfhohfupfgjtgfgsehtkeertddtfeejnecuhfhrohhmpedfffgrvhhiugcuvedrucftrghnkhhinhdfuceoughrrghnkhhinhgrthhthiesshhuugguvghnlhhinhhkmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpedvleefvdejtdeigfdtlefhtedugeevvefftefggfdvteekvedvjeefudeiieejueenucfkphepieeirdejiedrgeeirdduleehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplgduledvrdduieekrdeirddutdegngdpihhnvghtpeeiiedrjeeirdegiedrudelhedpmhgrihhlfhhrohhmpegurhgrnhhkihhnrghtthihsehsuhguuggvnhhlihhnkhhmrghilhdrtghomhdpnhgspghrtghpthhtohepuddprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprghuthhhpghushgvrhepughrrghnkhhinhgrthhthiesshhuugguvghnlhhinhhkmhgrihhlrdgtohhmpdhgvghoihhppegfufdpmhhtrghhohhstheptghmgidqrghlthdqrhhgohhuthdttddu
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from [192.168.6.104] (66.76.46.195) by cmx-alt-rgout001.mx-altice.prod.cloud.synchronoss.net (5.8.810) (authenticated as drankinatty@suddenlinkmail.com)
        id 636B531D0664B343 for linux-raid@vger.kernel.org; Sat, 3 Dec 2022 09:42:00 +0000
Message-ID: <91e80178-584e-5da5-213f-a7913ab5fec0@suddenlinkmail.com>
Date:   Sat, 3 Dec 2022 03:41:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     mdraid <linux-raid@vger.kernel.org>
References: <53c32c9a-c727-ca36-961d-4f3d3afd545f@suddenlinkmail.com>
 <60258a01-d13a-e969-fc7a-11f05a8880b5@thelounge.net>
From:   "David C. Rankin" <drankinatty@suddenlinkmail.com>
Organization: Rankin Law Firm, PLLC
Subject: Re: Revisit Old Issue - Raid1 (harmless still?) mismatch_cnt = 128 on
 scrub?
In-Reply-To: <60258a01-d13a-e969-fc7a-11f05a8880b5@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/2/22 16:07, Reindl Harald wrote:
> 
> 
> Am 02.12.22 um 22:49 schrieb David C. Rankin:
>> All,
>>
>>    I have a Raid1 array on boot that showed 0 mismatch count for a couple of 
>> years, but lately shows:
>>
>> mismatch_cnt = 128
> 
> sadly that's normal while i count it as a bug in mdadm
> 
> it depends more or less on random IO due raid-check and makes no sense at all 
> (besides it's non-fixable anyways for a mirrored array because only god could 
> know the truth)

Alas,

   It's kind of a "phase of the moon thing" as far as I understand it for 
Raid1. The only kicker is the "could be nothing" or "could be a real problem" 
that makes you a little uneasy. But I've had a mismatch count of 128 before 
and then it goes back to 0 a couple of scrubs later. Everything else checks 
out fine, so if there wasn't any change in mdadm to eliminate the, then I'll 
just continue with the "ignore it" approach and keep an eye on it to see if it 
goes back to 0 a couple of scrubs later.

-- 
David C. Rankin, J.D.,P.E.

