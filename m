Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9036C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  7 Mar 2022 16:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbiCGQZz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Mar 2022 11:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbiCGQZy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Mar 2022 11:25:54 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE125C858
        for <linux-raid@vger.kernel.org>; Mon,  7 Mar 2022 08:24:57 -0800 (PST)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nRGAJ-0003zT-FY;
        Mon, 07 Mar 2022 16:24:56 +0000
Message-ID: <42d8fe58-faa2-4228-2b75-9fc1d8ef002d@youngman.org.uk>
Date:   Mon, 7 Mar 2022 16:24:53 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: striping 2x500G to mirror 1x1T
Content-Language: en-GB
To:     Natanji <natanji@gmail.com>,
        David T-G <davidtg-robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220305044704.GB4455@justpickone.org>
 <335f6238-9329-7616-051f-075706ac9022@gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <335f6238-9329-7616-051f-075706ac9022@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 07/03/2022 14:19, Natanji wrote:
> Hello David,
> what you propose here should work, but be aware that you are essentially 
> first writing all data to the 2 smaller drives and then reading from 
> them only when the mirror 1 TB disk gets added. If there are bad sectors 
> that only gets dicovered while reading (not writing), you might lose 
> data. A much cleaner way would be to make a backup of your data disk and 
> then first crate the array with all disks, then write the data back from 
> your backup once the disks are in sync. You should definitely make a 
> backup or you could potentially lose data when creating this array.

But then David is in an equal pickle - what happens if the backup 
contains errors that only get discovered when reading, not writing ... 
no, David's plan is just the same as yours, his "half a mirror" is your 
backup, they suffer the same advantages and disadvantages.
> 
> I don't see the benefit of striping in your setup, by the way. For the 
> two smaller disks it might seem that this is beneficial for performance, 
> but since every write also needs to be made on the mirror, this will 
> essentially lead to your read/write head moving back and forth a lot, 
> no? Because if you write four consecutive chunks C1-C4 on the striped 
> side, two of these would be written to each smaller disk. And on the 1 
> TB disk side this would mean writing the sectors with only one 
> read/write head, each around 500GB apart from each other, and in a back 
> and worth fashion (although that might be optimized by queuing). So your 
> write performance could actually be *worse* than on a single drive, and 
> definitely not gain the 2x speed benefit of striping. For read 
> performance you might be okay, but nevertheless put unneccessary 
> mechanical wear on your 1 TB drive.
> 
> [C1 C3 ....] 500GB-1      [C2 C4 ....] 500GB-2
> [C1 C3 ... (500G space)  C2 C4 ....] 1TB
> 
> At least that's my understanding, someone correct me if I'm wrong and 
> mdadm handles such setups more intelligently (i.e. by laying out the 
> chunks completely linearly on the 1TB disk instead of 1-to-1 "mirroring" 
> the chunks on the 2x500G RAID0).

mdadm doesn't have a clue that the second device in your mirror is a 
raid0. As far as it is concerned you have two completely SEPARATE raids, 
a raid0-stripe, and a raid1-mirror.

So when reading from the mirror it should preferentially read from the 
raid0 because it's the faster device. Which means it WON'T put 
unnecessary mechanical wear on the 1TB device because it preferentially 
will only use it for writing. And because the layer above sees it as a 
1TB device, it won't be scattering writes all over the place. All three 
drives would see a "stream write to the mirror" as a stream write to the 
drive. A1,B1,A2,C1,A3,B2,A4,C2, ...

Cheers,
Wol
