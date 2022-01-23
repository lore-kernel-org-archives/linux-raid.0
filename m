Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230A5C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 23 Jan 2022 21:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbiAWVeG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 Jan 2022 16:34:06 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:59963 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235024AbiAWVeG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 23 Jan 2022 16:34:06 -0500
Received: from [192.168.0.2] (ip5f5aeacb.dynamic.kabel-deutschland.de [95.90.234.203])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D07E361E6478B;
        Sun, 23 Jan 2022 22:34:03 +0100 (CET)
Message-ID: <70008df6-ef90-6e8d-8a57-9b30077508e7@molgen.mpg.de>
Date:   Sun, 23 Jan 2022 22:34:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [dm-devel] Raid0 performance regression
Content-Language: en-US
To:     Roger Willcocks <roger@filmlight.ltd.uk>
Cc:     dm-devel@redhat.com, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Lukas Straub <lukasstraub2@web.de>
References: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
 <20220123180058.372f72ce@gecko.fritz.box>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220123180058.372f72ce@gecko.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Roger,


Am 23.01.22 um 19:00 schrieb Lukas Straub:
> CC'ing Song Liu (md-raid maintainer) and linux-raid mailing list.
> 
> On Fri, 21 Jan 2022 16:38:03 +0000 Roger Willcocks wrote:

>> we noticed a thirty percent drop in performance on one of our raid
>> arrays when switching from CentOS 6.5 to 8.4; it uses raid0-like

For those outside the CentOS universe, what Linux kernel versions are those?

>> striping to balance (by time) access to a pair of hardware raid-6
>> arrays. The underlying issue is also present in the native raid0
>> driver so herewith the gory details; I'd appreciate your thoughts.
>>
>> --
>>
>> blkdev_direct_IO() calls submit_bio() which calls an outermost
>> generic_make_request() (aka submit_bio_noacct()).
>>
>> md_make_request() calls blk_queue_split() which cuts an incoming
>> request into two parts with the first no larger than get_max_io_size()
>> bytes (which in the case of raid0, is the chunk size):
>>
>>    R -> AB
>>    
>> blk_queue_split() gives the second part 'B' to generic_make_request()
>> to worry about later and returns the first part 'A'.
>>
>> md_make_request() then passes 'A' to a more specific request handler,
>> In this case raid0_make_request().
>>
>> raid0_make_request() cuts its incoming request into two parts at the
>> next chunk boundary:
>>
>> A -> ab
>>
>> it then fixes up the device (chooses a physical device) for 'a', and
>> gives both parts, separately, to generic make request()
>>
>> This is where things go awry, because 'b' is still targetted to the
>> original device (same as 'B'), but 'B' was queued before 'b'. So we
>> end up with:
>>
>>    R -> Bab
>>
>> The outermost generic_make_request() then cuts 'B' at
>> get_max_io_size(), and the process repeats. Ascii art follows:
>>
>>
>>      /---------------------------------------------------/   incoming rq
>>
>>      /--------/--------/--------/--------/--------/------/   max_io_size
>>        
>> |--------|--------|--------|--------|--------|--------|--------| chunks
>>
>> |...=====|---=====|---=====|---=====|---=====|---=====|--......| rq out
>>        a    b  c     d  e     f  g     h  i     j  k     l
>>
>> Actual submission order for two-disk raid0: 'aeilhd' and 'cgkjfb'
>>
>> --
>>
>> There are several potential fixes -
>>
>> simplest is to set raid0 blk_queue_max_hw_sectors() to UINT_MAX
>> instead of chunk_size, so that raid0_make_request() receives the
>> entire transfer length and cuts it up at chunk boundaries;
>>
>> neatest is for raid0_make_request() to recognise that 'b' doesn't
>> cross a chunk boundary so it can be sent directly to the physical
>> device;
>>
>> and correct is for blk_queue_split to requeue 'A' before 'B'.
>>
>> --
>>
>> There's also a second issue - with large raid0 chunk size (256K), the
>> segments submitted to the physical device are at least 128K and
>> trigger the early unplug code in blk_mq_make_request(), so the
>> requests are never merged. There are legitimate reasons for a large
>> chunk size so this seems unhelpful.
>>
>> --
>>
>> As I said, I'd appreciate your thoughts.

Thank you for the report and the analysis.

Is the second issue also a regression? If not, I suggest to split it 
into a separate thread.


Kind regards,

Paul
