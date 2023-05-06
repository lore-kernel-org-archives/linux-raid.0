Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D7FC77B73
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 22:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjEFW3p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 18:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEFW3o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 18:29:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA9814348
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 15:29:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 475D82264A;
        Sat,  6 May 2023 22:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683412181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NQDoOPB/0zRWO+Roe0boAeQRS89Lo1mgKK/ExnLtk0=;
        b=fVQVGpsMAbFzQUWDX91CUaaFGTpjwtrx/RPogShzKF0EKwmQVWa/RozLBox8wuHAVrDHpS
        p4pL8CMLrlSdMERyTUEYqSOzZliZADpNo0dSFhOlcFBavRWoGVajSg9z7NN9kg30PuvRmm
        3M1Jj1pTREeaaCUPOZQZlN+G9vA7UaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683412181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NQDoOPB/0zRWO+Roe0boAeQRS89Lo1mgKK/ExnLtk0=;
        b=fxrtwPVexE/Myn9ktCU63bjChWxTJFK6+kkCRc+fCdJx4Ffbr4Esmq2syL4SIIumwSi7mF
        KC+CDuxmHtlpaOAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AF5601346B;
        Sat,  6 May 2023 22:29:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cr4iCtTUVmQZYwAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 06 May 2023 22:29:40 +0000
Message-ID: <7605c54f-670a-a804-b238-627cd561ce52@suse.de>
Date:   Sun, 7 May 2023 00:29:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: Second of 3 drives in RAID5 missing
Content-Language: en-US
To:     Alex Elder <elder@ieee.org>, linux-raid@vger.kernel.org
References: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/6/23 18:28, Alex Elder wrote:
> I have a 3-drive RAID5 that I set up more than 5 years ago.
> At some point, the "middle" drive failed (hardware failure).
> I bought a replacement and issued some commands to attempt
> to recover, and did *something* wrong.  I was too busy to
> spend time to fix this then, and one thing led to another,
> and now it's 2023 and I'd like to fire the array up again.
> 
> The current state is that /dev/md127 gets created automatically
> and it contains the two good disks (partitions).  I'm pretty
> sure this should be easy enough to recover if I issue the
> right commands to rebuild things.
> 
> The disks are 8TB Seagate Ironwolf drives. (ST8000VN0022-2EL)
> They are partitioned identically, with a GPT label.  The first
> partition starts at offset 2048 sectors and continues to the end.
> The RAID device was originally created with this command:
>    mdadm --create /dev/md/z --level=5 --raid-devices=3 /dev/sd{b,c,d}1
> 
> I'm going to provide the output of a few commands below, and
> will gladly provide whatever other information is required
> to get this fixed.
> 
> Thank you.
> 
>                      -Alex
> 
> root@meat:/# mdadm --version
> mdadm - v4.2 - 2021-12-30 - Ubuntu 4.2-3ubuntu1
> root@meat:/#
> 
> root@meat:/# mdadm --detail --scan
> INACTIVE-ARRAY /dev/md127 metadata=1.2 name=meat:z 
> UUID=8a021a34:f19bbc01:7bcf6f8e:3bea43a9
> root@meat:/#
> 
> root@meat:/# mdadm --detail /dev/md127
> /dev/md127:
>             Version : 1.2
>          Raid Level : raid5
>       Total Devices : 2
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 2
> 
>                Name : meat:z  (local to host meat)
>                UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
>              Events : 9534
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       49        -        /dev/sdd1
>         -       8       17        -        /dev/sdb1
> root@meat:/#
> 
> root@meat:/# ls -l /dev/sd[bcd]1
> brw-rw---- 1 root disk 8, 17 May  6 11:20 /dev/sdb1
> brw-rw---- 1 root disk 8, 33 May  6 11:20 /dev/sdc1
> brw-rw---- 1 root disk 8, 49 May  6 11:20 /dev/sdd1
> root@meat:/#
> 
> =========== Here's the disk that got replaced
> root@meat:/# mdadm --examine /dev/sdc1
> mdadm: No md superblock detected on /dev/sdc1.
> root@meat:/#
> 
> =========== Here are the other two  disks
> root@meat:/# mdadm --examine /dev/sd[bd]1
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
>             Name : meat:z  (local to host meat)
>    Creation Time : Sun Oct 22 21:19:23 2017
>       Raid Level : raid5
>     Raid Devices : 3
> 
>   Avail Dev Size : 15627786240 sectors (7.28 TiB 8.00 TB)
>       Array Size : 15627786240 KiB (14.55 TiB 16.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : 4cd855b7:ecba9064:b74a2182:bbc8a994
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Dec 13 16:51:21 2020
>    Bad Block Log : 512 entries available at offset 40 sectors
>         Checksum : be977447 - correct
>           Events : 9534
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 0
>     Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdd1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
>             Name : meat:z  (local to host meat)
>    Creation Time : Sun Oct 22 21:19:23 2017
>       Raid Level : raid5
>     Raid Devices : 3
> 
>   Avail Dev Size : 15627786240 sectors (7.28 TiB 8.00 TB)
>       Array Size : 15627786240 KiB (14.55 TiB 16.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : 1d2ce616:943d0c86:fa9ef8ad:87e31be0
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Dec 13 16:51:21 2020
>    Bad Block Log : 512 entries available at offset 40 sectors
>         Checksum : b6ece242 - correct
>           Events : 9534
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 2
>     Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
> root@meat:/#
> 
mdadm manage /dev/md127 --add /dev/sdd ?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

