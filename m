Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5B1C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Mar 2022 22:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350494AbiCHWwQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 17:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiCHWwP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 17:52:15 -0500
X-Greylist: delayed 102921 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 14:51:17 PST
Received: from titan.nuclearwinter.com (titan.nuclearwinter.com [150.136.49.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DCA4EF5A
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 14:51:17 -0800 (PST)
Received: from [10.0.0.102] (unknown [10.0.0.102])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by titan.nuclearwinter.com (Postfix) with ESMTPSA id 32398A7F19;
        Tue,  8 Mar 2022 17:51:16 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com 32398A7F19
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1646779876;
        bh=DHdcFUUQ0UcmX7G+en3lDfqdx7vb8dm3zRnRS8dFAU0=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=AgUvqLMM2JboBvhgSIite9XCbBd9panAzVHOTNozAjTs/tAdz6epepHDHVd11gdcw
         fXI+++hPE9q8zHJEshlQfk3exHXsDytNyKCD9+i7r7HlXJH/tyIKwgKmWue5RMU1HL
         3Vd7uffbITBwA0OetyCKzqvaNyFe/glkVUuyKYZ8=
Message-ID: <c7c568cf-14e8-b0ce-5690-35aecce9e784@nuclearwinter.com>
Date:   Tue, 8 Mar 2022 17:51:14 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Raid6 check performance regression 5.15 -> 5.16
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com>
 <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAPhsuW68V0ZO55_Un0vnrAt_+XpGRX3yq3nR=35f7P2d5iPvTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 8, 2022 at 3:50 PM Song Liu <song@kernel.org> wrote:
> On Mon, Mar 7, 2022 at 10:21 AM Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
>> I am seeing a 'check' speed regression between kernels 5.15 and 5.16.
>> One host with a 20 drive array went from 170MB/s to 11MB/s. Another host
>> with a 15 drive array went from 180MB/s to 43MB/s. In both cases the
>> arrays are almost completely idle. I can flip between the two kernels
>> with no other changes and observe the performance changes.
>>
>> Is this a known issue?
>
> I am not aware of this issue. Could you please share
>
>    mdadm --detail /dev/mdXXXX
>
> output of the array?
>
> Thanks,
> Song

Host A:
# mdadm --detail /dev/md1
/dev/md1:
            Version : 1.2
      Creation Time : Thu Nov 19 18:21:44 2020
         Raid Level : raid6
         Array Size : 126961942016 (118.24 TiB 130.01 TB)
      Used Dev Size : 9766303232 (9.10 TiB 10.00 TB)
       Raid Devices : 15
      Total Devices : 15
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Tue Mar  8 12:39:14 2022
              State : clean
     Active Devices : 15
    Working Devices : 15
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : bitmap

               Name : fubar:1  (local to host fubar)
               UUID : eaefc9b7:74af4850:69556e2e:bc05d666
             Events : 85950

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1
        3       8       49        3      active sync   /dev/sdd1
        4       8       65        4      active sync   /dev/sde1
        5       8       81        5      active sync   /dev/sdf1
       16       8       97        6      active sync   /dev/sdg1
        7       8      113        7      active sync   /dev/sdh1
        8       8      129        8      active sync   /dev/sdi1
        9       8      145        9      active sync   /dev/sdj1
       10       8      161       10      active sync   /dev/sdk1
       11       8      177       11      active sync   /dev/sdl1
       12       8      193       12      active sync   /dev/sdm1
       13       8      209       13      active sync   /dev/sdn1
       14       8      225       14      active sync   /dev/sdo1

Host B:
# mdadm --detail /dev/md1
/dev/md1:
            Version : 1.2
      Creation Time : Thu Oct 10 14:18:16 2019
         Raid Level : raid6
         Array Size : 140650080768 (130.99 TiB 144.03 TB)
      Used Dev Size : 7813893376 (7.28 TiB 8.00 TB)
       Raid Devices : 20
      Total Devices : 20
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Tue Mar  8 17:40:48 2022
              State : clean
     Active Devices : 20
    Working Devices : 20
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 128K

Consistency Policy : bitmap

               Name : mcp:1
               UUID : 803f5eb5:e59d4091:5b91fa17:64801e54
             Events : 302158

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1      65      145        1      active sync   /dev/sdz1
        2      65      177        2      active sync   /dev/sdab1
        3      65      209        3      active sync   /dev/sdad1
        4       8      209        4      active sync   /dev/sdn1
        5      65      129        5      active sync   /dev/sdy1
        6       8      241        6      active sync   /dev/sdp1
        7      65      241        7      active sync   /dev/sdaf1
        8       8      161        8      active sync   /dev/sdk1
        9       8      113        9      active sync   /dev/sdh1
       10       8      129       10      active sync   /dev/sdi1
       11      66       33       11      active sync   /dev/sdai1
       12      65        1       12      active sync   /dev/sdq1
       13       8       65       13      active sync   /dev/sde1
       14      66       17       14      active sync   /dev/sdah1
       15       8       49       15      active sync   /dev/sdd1
       19      66       81       16      active sync   /dev/sdal1
       16      66       65       17      active sync   /dev/sdak1
       17       8      145       18      active sync   /dev/sdj1
       18      66      129       19      active sync   /dev/sdao1

The regression was introduced somewhere between these two Fedora kernels:
5.15.18-200 (good)
5.16.5-200 (bad)

--Larkin

