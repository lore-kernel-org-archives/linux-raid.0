Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A51C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 18:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240147AbiDFSI5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240470AbiDFSHz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 14:07:55 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF62190EB2
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 09:46:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649263568; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=kWeyhsEQ31cWDRkH4l2riZGEh3TJnVB/HcG3zrr/gRV8UgbajTroNtErr6UnKrwZiimhXUesoSNpGvHIjLRdyYZx8tEKijU4XhMC7ZHK5f0Ge4xXOmINynLuJinlJxtQszm3H8GxIV8b469lHAAPPiiW5mOdSgU3PyV9YV9fQYQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649263568; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=QkiXEz/nKzYteiEb21oAWMBJ79MonU7jpPcdstNaAIM=; 
        b=PU8b1K9LLwq40eY/jCTzYOuRD6vDrf/zbDvqsUw6T28c7ijhBRjJICCR42sA3WYhx3NJew0m+rd4xhCRCPtWUAGrer33whG6Pj7A6saGCNTIORwwUt+/43fW2jioZaFoYH8LPYIRo2CkQWcTGjCpW1M5lGcp6pVe6WLM3/Qp4nk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1649263566307185.44288498971616; Wed, 6 Apr 2022 18:46:06 +0200 (CEST)
Date:   Wed, 6 Apr 2022 12:46:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Add RAID 1 chunksize test
Content-Language: en-US
To:     Doug Ledford <dledford@redhat.com>,
        Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220404070830.7795-1-mateusz.kusiak@intel.com>
 <53bc131b71b7f94210e507eed93390b1b3899246.camel@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <9653c1f1-1aae-3c5d-2a43-4cb3109392b0@trained-monkey.org>
In-Reply-To: <53bc131b71b7f94210e507eed93390b1b3899246.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/22 08:38, Doug Ledford wrote:
> On Mon, 2022-04-04 at 09:08 +0200, Mateusz Kusiak wrote:
>> Specifying chunksize for raid 1 is forbidden.
>> Add test for blocking raid 1 creation with chunksize.
>>
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>> ---
>>  tests/01r1create-chunk | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>  create mode 100644 tests/01r1create-chunk
>>
>> diff --git a/tests/01r1create-chunk b/tests/01r1create-chunk
>> new file mode 100644
>> index 00000000..717a5e5a
>> --- /dev/null
>> +++ b/tests/01r1create-chunk
>> @@ -0,0 +1,15 @@
>> +# RAID 1 volume, 2 disks, chunk 64
>> +# NEGATIVE test - creating raid 1 with chunksize specified is
>> forbidden
>> +
>> +num_disks=2
>> +level=1
>> +device_list="$dev0 $dev1"
>> +chunk=64
>> +
>> +# Create raid 1 with chunk 64k and fail
>> +if ! mdadm --create --run $md0 --auto=md --level=$level --
>> chunk=$chunk --raid-disks=$num_disks $device_list
>> +then
>> +       exit 0
>> +fi
>> +
>> +exit 1
> 
> This is a case of overkill IMO.  Chunk size with raid1 isn't really a
> problem and shouldn't result in mdadm refusing to work.  Chunk size with
> raid1 simply has no effect and should just be ignored with at most a
> warning by mdadm.

I agree with Doug here. I think a warning from mdadm that chunksize
makes no sense for raid1 would be good, but having a failed test over it
makes little sense. If anything the test should detect the warning is
happening.

Thanks,
Jes



