Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC80FC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 15:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7B7860F70
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 15:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhKBP4T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 11:56:19 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17283 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232135AbhKBP4S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 11:56:18 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635868417; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=grgLG31DP8faliW/JRuEXLGy8oPZLKoPRFWubShAgBn197OLN3I7SV5jh35l+xdrnCwyBzD/GD7R8ZcGi09QTyluA4yQslMgUk/jo94YxniFDIEaNbROHYB2B3OeGzfpy6+BpHNPi39SkEvmxuvieiopDkMG4WERdiaJ7l8EVf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635868417; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Gr+VaL1c1joEE15crCXLCJ2VdNHEQWBSfeb1VRp3qW8=; 
        b=OlRlWlMDx0680Hvpqbk07+8xApV5OZC4+68GTIhEfudmj/CRYh5mEgjhLhSvPgQospydgV+uYwROP0agGTYrUglhN8zd6CEg+saulcCmLsCo2gfGse/fmpK2x7gyDmH/pj+A8hLjogdJYa7pYGCOIgv6dv6VLQ/kgGYnVjNP++c=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635868417183589.8306177256504; Tue, 2 Nov 2021 16:53:37 +0100 (CET)
Subject: Re: Proposal of changing generating version of mdadm
To:     "Tanska, Kinga" <kinga.tanska@intel.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <MN2PR11MB3776740E926BE3FE37C8B6E389BE9@MN2PR11MB3776.namprd11.prod.outlook.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <835df064-87ca-a3c1-bd29-d8df62c79da3@trained-monkey.org>
Date:   Tue, 2 Nov 2021 11:53:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <MN2PR11MB3776740E926BE3FE37C8B6E389BE9@MN2PR11MB3776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/20/21 8:43 AM, Tanska, Kinga wrote:
> Hi,
> 
> recently we diagnosed few issues with 'mdadm -version' output.
> Main problem is that end output varies on few conditions. We come with
> simplified proposal. First let's describe current schema:
> 
> mdadm - version - date - extraversion
> (example: mdadm - v4.2-rc2 - 2021-08-02 - extraversion)
> 
> or
> 
> mdadm - version - date
> (example: mdadm - v4.2-rc2 - 2021-08-02).
> 
> VERSION could be taken from code (see ReadMe.c:31), but when git is
> installed and .git directory is available in mdadm workspace, version
> is replaced with output from # git describe HEAD command. It is assumed
> that git command should return last tag from repo, which should contain
> information about last release. This might not be true, especially if user
> uses tags to mark internal milestones or custom mdadm spins.
> 
> The second problem is DATE, which corresponds to date of last release.
> When few patches are picked onto HEAD date is not reliable. In my opinion
> DATE is not needed. Usually, packages do not contain this element, e.g.
> -	# git --version
> 		git version 2.27.0
> -	# gcc --version
> 		gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)
> -	# yum --version
> 		4.2.23
> 
> To make it const and reliable, I propose removing DATE and always
> use VERSION from code. VERSION shall keep general release information.
> I would like to move the changeable elements into EXTRAVERSION. This
> field will respect following conditions:
> -	user definition first
>        	(by respecting EXTRAVERSION=xxx during compilation)
> -	if not defined by user, result of # git describe HEAD
> -	else empty.
> 
> Example output:
> mdadm - version - extraversion (example: mdadm - v4.2-rc2 - extraversion).
> Thanks for any opinion about this proposition.

Hi Kinga,

I am not against changing the format, however I worry that doing so may
break scripts and tools in the field that nobody is maintaining or have
thought of. If we are to change the output, I suggest making a new flag
that provides the details you want and we can deprecate the old one, but
leave it in place.

Thoughts?

Jes
