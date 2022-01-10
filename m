Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02882C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 10 Jan 2022 09:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbiAJJBv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Jan 2022 04:01:51 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:27391 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242382AbiAJJAT (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 10 Jan 2022 04:00:19 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1n6qXI-0007AD-3s; Mon, 10 Jan 2022 09:00:16 +0000
Message-ID: <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
Date:   Mon, 10 Jan 2022 09:00:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Feature request: Add flag for assuming a new clean drive
 completely dirty when adding to a degraded raid5 array in order to increase
 the speed of the array rebuild
Content-Language: en-GB
To:     =?UTF-8?B?SmFyb23DrXIgQ8OhcMOtaw==?= <jaromir.capik@email.cz>,
        linux-raid@vger.kernel.org
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/01/2022 14:21, Jaromír Cápík wrote:
> In case of huge arrays (48TB in my case) the array rebuild takes a couple of
> days with the current approach even when the array is idle and during that
> time any of the drives could fail causing a fatal data loss.
> 
> Does it make at least a bit of sense or my understanding and assumptions
> are wrong?

It does make sense, but have you read the code to see if it already does it?

And if it doesn't, someone's going to have to write it, in which case it 
doesn't make sense, not to have that as the default.

Bear in mind that rebuilding the array with a new drive is completely 
different logic to doing an integrity check, so will need its own code, 
so I expect it already works that way.

I think you've got two choices. Firstly, raid or not, you should have 
backups! Raid is for high-availability, not for keeping your data safe! 
And secondly, go raid-6 which gives you that bit extra redundancy.

Cheers,
Wol
