Return-Path: <SRS0=sV2i=CU=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D49DC43461
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 20:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0232075A
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 20:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RuU3YNdw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgIKUha (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Sep 2020 16:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgIKUh2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Sep 2020 16:37:28 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AD4C061573
        for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2020 13:37:28 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id w3so13527020ljo.5
        for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2020 13:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Czj2h33hquAqyK6zFcJDEB8etG44YD25yDjUwyErjhM=;
        b=RuU3YNdwMNT4Fyl5Zi14LszzWD9vgc5rzGpadPmExFAEzqzkk76uDTaFFKJ1Ebt506
         2FGLDX09GumjFrSyjV4RZdGBEwZfpegyoup1AoNKSVxDiEK2AtePmhc5JMLh/FWWTwzK
         LtotnZXCZDHcOAgXLdDM/Ds93f6tzcEpzwiwOL0A2NTTOj/SxPgERwqmUk38+FVaD/+9
         4PT2KIZ5KlmJBGydwmH6VclmZUox4uv9ATFiq6Zl4bdiDeA4xp6iSftUo9iZvVqEVbdy
         ktU1cEhka3wqSXv6C8ssiQSppecJAUsVvGAM/J+BIbyiiffrlm/Kx4zHMIj0cRZrzJyN
         Io4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Czj2h33hquAqyK6zFcJDEB8etG44YD25yDjUwyErjhM=;
        b=AlUEbcNOz3kse++pH5UDOKfFKIiE54fdnP5MYS3OoJAirYAeYmG0VcycFt2eXcsr59
         dVSEi97Ywd6lrj+nuHykVKNYp907E+oNoPEsK/TCHYlN6wu+ltSVeFaSRmnnIG+NGTNY
         +kIA0rau61CeFBFgn5eTDjOgwO2De10D4Z/dmMiGqqrIMilyydmbQlmobrDmAsotZXRd
         6hTlzPBrmKkteV9tMN9WDHMnPkc7s3Cixe0HR4g5rcJoK2qhnia0YrKDmpBN/dMEdIvL
         Dp9mpX01sghYkTPLt4K4vgLo8aFGzSz0bd0mm31gE3RREotV+695jpyLB7usfE7j4lM+
         3sJw==
X-Gm-Message-State: AOAM530TWeCIrHKGNDJjuH4riRGlALANW6TSdQxOtKIiE2V7SxWfaYBr
        RkVuiIJhMPKb0UnfxAMWOwM4/Iof0lmadTLnXaM=
X-Google-Smtp-Source: ABdhPJxbFss+Y11Q/oS28DOrJEIDwFk2xj9/3Walag2vhZqqyZqqjgPnimSWC+R9517vLE+YhcN4+tsO1qZDb02WPlg=
X-Received: by 2002:a2e:8841:: with SMTP id z1mr1355467ljj.292.1599856646430;
 Fri, 11 Sep 2020 13:37:26 -0700 (PDT)
MIME-Version: 1.0
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net> <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com> <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com> <6872a42c-5c27-e38a-33ab-10ec01723961@youngman.org.uk>
 <d0aeb41b-09d4-b756-05ee-f0b3da486532@verizon.net> <20200829100256.57e8d57b@natsu>
 <55a16008-f6ff-a44f-6e7c-e67bac4b02a6@gmail.com> <CAAMCDec9xgnoA0OLVJuCNxS4X5aXE7F771X07_rg0RZH-vmU1g@mail.gmail.com>
 <ad54a1fa-2dc7-7e30-b02d-e5aa0d9c7e88@gmail.com> <CAAMCDed6HPj3uO8+uUPYb-=5Rurp5LVYsDmMvmmtZiCEi5i39A@mail.gmail.com>
 <377f4acd-a39f-5715-b130-23c395ef0588@verizon.net>
In-Reply-To: <377f4acd-a39f-5715-b130-23c395ef0588@verizon.net>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 11 Sep 2020 15:37:14 -0500
Message-ID: <CAAMCDefEGFxURV2c6wQjpjwNsos1FoV-sRhh3xzNj70BZa04zQ@mail.gmail.com>
Subject: Re: Best way to add caching to a new raid setup.
To:     "R. Ramesh" <rramesh@verizon.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It is simpler, and has very simple to maintain moving parts.  I have
been a linux admin for 20+ years, and a professional unix admin for
longer, and too often complicated seems nice but has burned me with
bugs and other unexpected results, so simple is best.  The daily move
uses nothing complicated and can be expected to work on any unix
system that has ever existed and relies on heavily used operations
that have a high probability of working and of being caught quickly as
broken if they did not work.  Any of the others are a bit more
complicated, and more likely to have bugs and less likely to get
caught as quick as the moving parts I rely on.  I also wanted to be
able to spin down my array for any hours when no one is watching the
dvr (usually this is 18+ hours per day, x 7 drives ==   1.25kw/day, or
37kw/month, or $4-$10 depending on power costs), and I also have
motion software collecting security cams that go to the SSD and are
also copied onto the array nighty.   The security cams would have kept
the array spinning when anything moved anywhere outside so pretty much
100% of the time.

On Fri, Sep 11, 2020 at 1:39 PM R. Ramesh <rramesh@verizon.net> wrote:
>
> On 8/30/20 10:42 AM, Roger Heflin wrote:
> > The LSI should be a good controller as long as you the HBA fw and not
> > the raid fw.
> >
> > I use an LSI with hba + the 8 AMD chipset sata ports, currently I have
> > 12 ports cabled to hot swap bays but only 7+boot disk used.
> >
> > How many recording do you think you will have and how many
> > clients/watchers?  With the SSD handling the writes for recording my
> > disks actually spin down if no one is watching anything.
> >
> > The other trick the partitions let me do is initially I moved from 1.5
> > -> 3tb disks (2x750 -> 4x750) and once I got 3-3tbs in I added the 2
> > more partitions raid6(+1.5TB) (I bought the 3tb drives slowly), then
> > the next 3tb gets added to all 4 partitions (+3TB).
> >
> > On reads at least each disk can do at least 50 iops, and for the most
> > part the disks themselves are very likely to cache the entire track
> > the head goes over, so a 2nd sequential read likely comes from the
> > disk's read cache and does not have to actually be read.  So several
> > sequential workloads jumping back and forth do not behave as bad as
> > one would expect.  Write are a different story and a lot more
> > expensive.  I isloate those to ssd and copy them in the middle of the
> > night when it is low activity.  And since they are being copied as big
> > fast streams one file at a time they end up with very few fragments
> > and write very quickly.   The way I have mine setup mythtv will find
> > the file whether it is on the ssd recording directory or the raid
> > recording directory, so when I mv the files nothing has to be done
> > except the mv.
> >
> >
> > On Sat, Aug 29, 2020 at 7:56 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
> >> On 8/29/20 4:26 PM, Roger Heflin wrote:
> >>> It should be worth noting that if you buy 2 exactly the same SSD's at
> >>> the same time and use them in a mirror they are very likely to be
> >>> wearing about the same.
> >>>
> >>> I am hesitant to go much bigger on disks, especially since the $$/GB
> >>> really does not change much as the disks get bigger.
> >>>
> >>> And be careful of adding on a cheap sata controller as a lot of them work badly.
> >>>
> >>> Most of my disks have died from bad blocks causing a section of the
> >>> disk to have some errors, or bad blocks on sections causing the array
> >>> to pause for 7 seconds.  Make sure to get a disk with SCTERC settable
> >>> (timeout when bad blocks happen, otherwise the default timeout is a
> >>> 60-120seconds, but with it you can set it to no more than 7 seconds).
> >>>    In the cases where the entire disk did not just stop and is just
> >>> getting bad blocks in places, typically you have time as only a single
> >>> section is getting bad blocks, so in this case having sections does
> >>> help.    Also note that mdadm with 4 sections like I have will only
> >>> run a single rebuild at a time as mdadm understands that the
> >>> underlying disks are shared, this makes replacing a disk with 1
> >>> section or 4 sections basically work pretty much the same.  It does
> >>> the same thing on the weekly scans, it sets all 4 to scan, and it
> >>> scans 1 and defers the other scan as disks are shared.
> >>>
> >>> It seems to be a disk completely dying is a lot less often than badblock issues.
> >>>
> >>> On Sat, Aug 29, 2020 at 3:50 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
> >>>> On 8/29/20 12:02 AM, Roman Mamedov wrote:
> >>>>> On Fri, 28 Aug 2020 22:08:22 -0500
> >>>>> "R. Ramesh" <rramesh@verizon.net> wrote:
> >>>>>
> >>>>>> I do not know how SSD caching is implemented. I assumed it will be
> >>>>>> somewhat similar to memory cache (L2 vs L3 vs L4 etc). I am hoping that
> >>>>>> with SSD caching, reads/writes to disk will be larger in size and
> >>>>>> sequential within a file (similar to cache line fill in memory cache
> >>>>>> which results in memory bursts that are efficient). I thought that is
> >>>>>> what SSD caching will do to disk reads/writes. I assumed, once reads
> >>>>>> (ahead) and writes (assuming writeback cache) buffers data sufficiently
> >>>>>> in the SSD, all reads/writes will be to SSD with periodic well organized
> >>>>>> large transfers to disk. If I am wrong here then I do not see any point
> >>>>>> in SSD as a cache. My aim is not to optimize by cache hits, but optimize
> >>>>>> by preventing disks from thrashing back and forth seeking after every
> >>>>>> block read. I suppose Linux (memory) buffer cache alleviates some of
> >>>>>> that. I was hoping SSD will provide next level. If not, I am off in my
> >>>>>> understanding of SSD as a disk cache.
> >>>>> Just try it, as I said before with LVM it is easy to remove if it doesn't work
> >>>>> out. You can always go to the manual copying method or whatnot, but first why
> >>>>> not check if the automatic caching solution might be "good enough" for your
> >>>>> needs.
> >>>>>
> >>>>> Yes it usually tries to avoid caching long sequential reads or writes, but
> >>>>> there's also quite a bit of other load on the FS, i.e. metadata. I found that
> >>>>> browsing directories and especially mounting the filesystem had a great
> >>>>> benefit from caching.
> >>>>>
> >>>>> You are correct that it will try to increase performance via writeback
> >>>>> caching, however with LVM that needs to be enabled explicitly:
> >>>>> https://www.systutorials.com/docs/linux/man/7-lvmcache/#lbAK
> >>>>> And of course a failure of that cache SSD will mean losing some data, even if
> >>>>> the main array is RAID. Perhaps should consider a RAID of SSDs for cache in
> >>>>> that case then.
> >>>>>
> >>>> Yes, I have 2x500GB ssds for cache. May be, I should do raid1 on them
> >>>> and use as cache volume.
> >>>> I thought SSDs are more reliable and even when they begin to die, they
> >>>> become readonly before quitting.  Of course, this is all theory, and I
> >>>> do not think standards exists on how they behave when reaching EoL.
> >>>>
> >>>> Ramesh
> >>>>
> >> My SSDs are from different companies and bought at different times
> >> (2019/2016, I think).
> >>
> >> I have not had many hard disk failures. However, each time I had one, it
> >> has been a total death. So, I am a bit biased. May be with sections, I
> >> can replace one md at a time and letting others run degraded. I am sure
> >> there other tricks. I am simply saying it is a lot of reads/writes, and
> >> of course computation, in cold replacement of disks in RAID6 vs. RAID1.
> >>
> >> Yes, larger disks are not cheaper, but they use one SATA port vs.
> >> smaller disks. Also, they use less power in the long run (mine run
> >> 24x7). That is why I have a policy of replacing disks once 2x size disks
> >> (compared to what I currently own) become commonplace.
> >>
> >> I have a LSI 9211 SAS HBA which is touted to be reliable by this community.
> >>
> >> Regards
> >> Ramesh
> >>
>
> Roger,
>
>    Just curious, in your search for a SSD solution to mythtv recording,
> did you consider overlayfs, unionfs or mergerfs? If you did, why did you
> decide that a simple copy is better?
>
> Ramesh
>
