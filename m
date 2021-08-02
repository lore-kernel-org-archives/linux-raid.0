Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43FBC432BE
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68B060F9E
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhHBOw4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:52:56 -0400
Received: from l2ms.rz.uni-kiel.de ([134.245.11.210]:52386 "EHLO
        l2ms.rz.uni-kiel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhHBOw4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 10:52:56 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2021 10:52:55 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=uni-kiel.de
        ; s=20180612; h=Content-Type:MIME-Version:Message-ID:Date:Subject:To:From:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j+sM0ZbXJ66BmdFk+GSYPVqFo5lBSB63zKJcPkyTnyE=; i=@physik.uni-kiel.de; b=Oa4
        5/Fjdf87X8VE6uPczHLbTY6l8sjWbwaNL7efwS63KDKODqodvGBFjMWn1edBNk3AjPGclY/GEiQft
        LFbhb07x1E3cHMdGrBxhK3cBgQxRpQB/ujADd2J586n+8w0u26P/CutLwLsamPBb8mH2JXuKKtb9P
        5k/BW+cQb0hQfM=;
Received: from localhost ([127.0.0.1])
        by l2ms.rz.uni-kiel.de with esmtp (Exim 4.94.2)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mAZ5T-000ByY-Jz
        for linux-raid@vger.kernel.org; Mon, 02 Aug 2021 16:38:39 +0200
X-Virus-Scanned: by amavisd-new (Uni-Kiel/l2ms-sc)
Received: from l2ms.rz.uni-kiel.de ([IPv6:::1])
        by localhost (l2ms.rz.uni-kiel.de [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id sC01BzJZHEfp for <linux-raid@vger.kernel.org>;
        Mon,  2 Aug 2021 16:38:39 +0200 (CEST)
Received: from frontend2.mail.uni-kiel.de ([134.245.12.49])
        by l2ms.rz.uni-kiel.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mAZ5T-000ByI-G3; Mon, 02 Aug 2021 16:38:39 +0200
Received: from falbala.ieap.uni-kiel.de ([134.245.71.168]:40172)
        by frontend2.mail.uni-kiel.de with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mAZ5S-000Axa-Ui; Mon, 02 Aug 2021 16:38:39 +0200
Received: from localhost ([127.0.0.1] helo=falbala)
        by falbala.ieap.uni-kiel.de with esmtp (Exim 4.94.2)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mAZ5S-0000hC-HJ; Mon, 02 Aug 2021 16:38:38 +0200
From:   =?utf-8?Q?Stephan_B=C3=B6ttcher?= <boettcher@physik.uni-kiel.de>
To:     linux-raid@vger.kernel.org
Subject: help channel for md raid?
Date:   Mon, 02 Aug 2021 16:38:38 +0200
Message-ID: <s6n8s1j6he9.fsf@falbala.ieap.uni-kiel.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Moin!

May I ask a question on this list, or is this strictly for development?

Thanks,
Stephan


My qustion is how to translate sector numbers from a RAID6 as in

> Aug  2 01:32:28 falbala kernel: md8: mismatch sector in range 1460408-1460416

to ext4 inode numbers, as in

> debugfs: icheck 730227 730355 730483 730611
> Block   Inode number
> 730227  30474245
> 730355  30474245
> 730483  30474245
> 730611  30474245

Is there a list, channel, matrix room for this kind of questions?
Are there tools to do what I need?
Is the approach below sensible?

It is a RAID6 with six drives, one of them failed.
A check yielded 378 such mismatches.

I assume the sectors count from the start of the `Data Offset`.
`ext4 block numbers` count from the start of the partition?
Is that correct?

The failed drive has >3000 unreadble sectors and became very slow.

#! /usr/bin/gawk -f

BEGIN {
	SS = 512
	CS = 0x80000/SS
	BS = 4096/SS
	N  = 4
}
/mismatch sector in range/ {
	split($11,A,/-/); 
	S = A[1]; 
	M = S%CS; 
	C = S/CS;
	B = (C*N*CS + M)/BS
	printf "icheck"
	for (i=0; i<N; i++) printf " %u", B + i*CS/BS 
	printf "\n"
}


/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d58e68a2:7d9e9218:1bb61653:c295ae02
           Name : falbala:8  (local to host falbala)
  Creation Time : Wed Aug 20 12:23:51 2014
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5440837632 (2594.39 GiB 2785.71 GB)
     Array Size : 10881675264 (10377.57 GiB 11142.84 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=0 sectors
          State : clean
    Device UUID : 16ee808f:9cf5420e:270cc442:db7768b6

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Aug  2 09:27:57 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 2b557999 - correct
         Events : 405815

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA.AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d58e68a2:7d9e9218:1bb61653:c295ae02
           Name : falbala:8  (local to host falbala)
  Creation Time : Wed Aug 20 12:23:51 2014
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5440837632 (2594.39 GiB 2785.71 GB)
     Array Size : 10881675264 (10377.57 GiB 11142.84 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 28c5ded0:c005aaf2:167d3af3:8714b48c

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Aug  2 09:27:57 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d7dc6e93 - correct
         Events : 405815

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA.AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d58e68a2:7d9e9218:1bb61653:c295ae02
           Name : falbala:8  (local to host falbala)
  Creation Time : Wed Aug 20 12:23:51 2014
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5440837632 (2594.39 GiB 2785.71 GB)
     Array Size : 10881675264 (10377.57 GiB 11142.84 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 1e9be3ef:f6f44ef4:cd4c39d4:002b515c

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Aug  2 09:27:57 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a92219f4 - correct
         Events : 405815

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAA.AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d58e68a2:7d9e9218:1bb61653:c295ae02
           Name : falbala:8  (local to host falbala)
  Creation Time : Wed Aug 20 12:23:51 2014
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5440837632 (2594.39 GiB 2785.71 GB)
     Array Size : 10881675264 (10377.57 GiB 11142.84 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : active
    Device UUID : e85da470:24a385b8:ae66eacd:d822539d

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Aug  2 01:24:06 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 28d023be - correct
         Events : 400427

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d58e68a2:7d9e9218:1bb61653:c295ae02
           Name : falbala:8  (local to host falbala)
  Creation Time : Wed Aug 20 12:23:51 2014
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5440837632 (2594.39 GiB 2785.71 GB)
     Array Size : 10881675264 (10377.57 GiB 11142.84 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 48223f81:5c9a0ddd:ff0d1782:57941c27

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Aug  2 09:27:57 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9be57126 - correct
         Events : 405815

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAA.AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : d58e68a2:7d9e9218:1bb61653:c295ae02
           Name : falbala:8  (local to host falbala)
  Creation Time : Wed Aug 20 12:23:51 2014
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5440837632 (2594.39 GiB 2785.71 GB)
     Array Size : 10881675264 (10377.57 GiB 11142.84 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 881ee37d:810e582a:bc0d4841:27916f6b

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Aug  2 09:27:57 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e957ddfe - correct
         Events : 405815

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA.AA ('A' == active, '.' == missing, 'R' == replacing)


-- 
Stephan
