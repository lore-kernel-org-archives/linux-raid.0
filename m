From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Thu, 14 Feb 2013 18:40:56 -0700
Message-ID: <80A5C958-6E76-49BD-9CDC-3E8705B401C5@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <51157141.90205@hardwarefreak.com> <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com> <511D8AEF.8040202@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511D8AEF.8040202@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
List-Id: linux-raid.ids


On Feb 14, 2013, at 6:10 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
> 
> So assuming I don't mind wasting a few MB per disk (I was leaving empty
> space at the end of the partition anyway), what would I need to instruct
> fdisk and/or md to do to get the alignment right?
> 
> Current partition/disk is as follows:
> /dev/sdc1              63   931769999   465884968   fd  Lnx RAID auto

Yeah the old fdisk starts at LBA 63 which is not good because it's neither 4K nor 8K aligned. For a long time now fdisk starts new ones at 2048 which is 1MB aligned (and is of course also 8KB and 4KB aligned, among others so it's just easier to do that.) But for 4K and 8K alignment, start LBA 48, 64, 80, etc are also valid.

Chris Murphy