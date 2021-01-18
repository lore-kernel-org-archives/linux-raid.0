Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44EE7C433DB
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 03:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0627322475
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 03:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbhARDNx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jan 2021 22:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731011AbhARDNs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Jan 2021 22:13:48 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFE0C061573
        for <linux-raid@vger.kernel.org>; Sun, 17 Jan 2021 19:13:07 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id 6so21661226ejz.5
        for <linux-raid@vger.kernel.org>; Sun, 17 Jan 2021 19:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hh5n/cARC69O9cVp678QPoXsARrul9dLAikdvUJvio4=;
        b=Koo1wO5xHV8p31fpTyC0G60qQi5mUrprvK5k0SLANZzBxNehDfL6D2GktHz/DqOoEg
         QRVOK3juSHFw9rAvMvkV+/yfnChp3a7fd1/6aJmG7rdIR+VunZluPp82mLdUqwxx3wcm
         6uy4CqsziDkz0K3WoJq3qY2avdA/uTDerz3vASxd1440rQxPUItmGYhWitMT2R8YrU6P
         09faX61s6O7Ij+zMMisBA8sQBlocqF/8VHAK0ZVXZHjayPXzs2xkPD1GzuhASbmaSfJj
         kwdfLV5yIexmtCDonhQy80dZChd7G6N4OhoIA4lPN+78kELQUx/deShPgvk39PJIBRHt
         9JYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hh5n/cARC69O9cVp678QPoXsARrul9dLAikdvUJvio4=;
        b=hChoLfYp127lvS/PHFak5nEUNX/05RYOKw6s+5i/8iNEEQRbYHGH0/YeuW3jbGBIID
         e88xmoChcE45xti5eUSgr5XUWw8GuN6CJjviZBIt7UmmYr8gkz2mVJGz9veQuN0bybhF
         tGulAzYGAvUIgZFL4KM5gdJbq1dspMsbK3bvPP1YKnNLDb2YM1oyBizsugRY04KolB1U
         ZphfzI0UmbhPf6pI5hT7Vw/XuXNbpV/SkQzxgoVW571I11ByYJBavVTJa8zkenSUBfe7
         I12YIIPpBXHcpfKgndglVG1vPPg9NMPu5aDfhxVmy6/R5s8m4oXwKGsrqsxBj/G2J3so
         ZpLQ==
X-Gm-Message-State: AOAM533FFHzoRkT73bJN+SrHiw1CN64vSqthGGt3PjratKNjOsn0roWw
        FzrXCsxJCHNPYRudWZmEdP2MDyAk3+zN0mWSuk41BT1WglE=
X-Google-Smtp-Source: ABdhPJyOjEB4AH1IOBntehECml/fYCZXOnX26L3GrIP4vNApOKIbXyVBuZR+B2VPTOgUa76MVrsi96Cgkk/roaW4Zpg=
X-Received: by 2002:a17:907:104c:: with SMTP id oy12mr15820276ejb.503.1610939586393;
 Sun, 17 Jan 2021 19:13:06 -0800 (PST)
MIME-Version: 1.0
References: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
 <87eeijjcgo.fsf@notabene.neil.brown.name>
In-Reply-To: <87eeijjcgo.fsf@notabene.neil.brown.name>
From:   Nathan Brown <nbrown.us@gmail.com>
Date:   Sun, 17 Jan 2021 21:12:55 -0600
Message-ID: <CAHikZs7EKe2H5OYdxd5dwZ8WCs8fdVp-5BWku0vQ5Bb-yCstCw@mail.gmail.com>
Subject: Re: Self inflicted reshape catastrophe
To:     NeilBrown <neil@brown.name>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It was this part of the original post

> The raid didn't automatically assemble so I did
> `mdadm --assemble` but really screwed up and put the 5 new disks in a
> different array

Basically, I did an `mdadm --assemble /dev/md1 <new disks for md0>`
instead of `mdadm --assemble /dev/md0 <new disks for md0>`. Further
complicated by the fact the md1 was missing a disk, so I let 1 of the
5 disks become a full member md1 since I didn't catch my error in time
and enough recovery on md1 had occurred to wipe out any data transfer
from the reshape on md0. The other 4 became hot spares. This wiped the
super block on those 5 new disks, the super blocks no longer contain
the correct information showing the original reshape attempt on md0.

I have yet to dive into the code but it seems likely that I can
manually reconstruct the appropriate super blocks for these 4 disks
that still contain valid data as a result of the reshape with a worst
case of ~1/5th data loss.

Here are the `mdadm --examine` for the 4 remaining drives destined for
md0, they believe they belong to md1 (a 6 x 4tb raid 5)

/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
           Name : any:1
  Creation Time : Sun Apr  6 05:23:45 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 19532619776 (9313.88 GiB 10000.70 GB)
     Array Size : 19534425600 (18629.48 GiB 20003.25 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 249856 sectors
   Super Offset : 8 sectors
   Unused Space : before=249776 sectors, after=11718849536 sectors
          State : clean
    Device UUID : 2e3e6281:d6735073:c92ffd33:cb6d1413

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Jan 14 03:18:04 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : e87847d5 - correct
         Events : 55628

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
           Name : any:1
  Creation Time : Sun Apr  6 05:23:45 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 19532619776 (9313.88 GiB 10000.70 GB)
     Array Size : 19534425600 (18629.48 GiB 20003.25 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 249856 sectors
   Super Offset : 8 sectors
   Unused Space : before=249776 sectors, after=11718849536 sectors
          State : clean
    Device UUID : 268fa8cf:0299a907:5f76dd12:94f78cf2

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Jan 14 03:18:03 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 89708e55 - correct
         Events : 55627

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdm1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
           Name : any:1
  Creation Time : Sun Apr  6 05:23:45 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 19532619776 (9313.88 GiB 10000.70 GB)
     Array Size : 19534425600 (18629.48 GiB 20003.25 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 249856 sectors
   Super Offset : 8 sectors
   Unused Space : before=249776 sectors, after=11718849536 sectors
          State : clean
    Device UUID : d8fa02f7:8dd22cea:06d0de1d:32d4039d

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Jan 14 03:37:53 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 48c66f6b - correct
         Events : 55861

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

/dev/sdn1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : f464edaa:6338d020:7541f151:678234d2
           Name : big-nas:1
  Creation Time : Sun Apr  6 05:23:45 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 19532619776 (9313.88 GiB 10000.70 GB)
     Array Size : 19534425600 (18629.48 GiB 20003.25 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 249856 sectors
   Super Offset : 8 sectors
   Unused Space : before=249776 sectors, after=11718849536 sectors
          State : clean
    Device UUID : f6c7b906:7aa7bbe7:aec61998:d3183973

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Jan 14 13:04:45 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 24b2884e - correct
         Events : 62212

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

The 5th and final 10tb disk I allowed to become the 6th member of the
6 x 4tb raid 5 after my screwup

/dev/sdo1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : f464edaa:6338d020:7541f151:678234d2
           Name : big-nas:1
  Creation Time : Sun Apr  6 05:23:45 2014
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 19532619776 (9313.88 GiB 10000.70 GB)
     Array Size : 19534425600 (18629.48 GiB 20003.25 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 249856 sectors
   Super Offset : 8 sectors
   Unused Space : before=249776 sectors, after=11718849536 sectors
          State : clean
    Device UUID : 527db0c9:1636b7c4:06afabaf:35d6db73

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Jan 16 06:11:30 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad
blocks present.
       Checksum : dcdbb6cf - correct
         Events : 62885

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

On Sun, Jan 17, 2021 at 6:49 PM NeilBrown <neil@brown.name> wrote:
>
> On Thu, Jan 14 2021, Nathan Brown wrote:
>
> > Scenario:
> >
> > I had a 4 by 10TB raid 5 array and was adding 5 more disks and
> > reshaping it to a raid6. This was working just fine until I got a
> > little too aggressive with perf tuning and caused `mdadm` to
> > completely hang. I froze the rebuild and rebooted the server to wipe
> > away my tuning mess. The raid didn't automatically assemble so I did
> > `mdadm --assemble` but really screwed up and put the 5 new disks in a
> > different array. Not sure why the superblock on those disks didn't
> > stop `mdadm` from putting them into service but the end result was the
> > superblock on those 5 new drives got wiped. That array was missing a
>
> What does this mean "the superblock on those 5 new drives got wiped"?
> How do you think that happened.
> Can you please report the current super blocks (mdadm --examine) anyway
> please.
>
> NeilBrown
