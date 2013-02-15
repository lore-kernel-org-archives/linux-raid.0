From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Thu, 14 Feb 2013 22:14:56 -0700
Message-ID: <C0297DA6-F16C-4527-A129-050C3BD6121D@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <51157141.90205@hardwarefreak.com> <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com> <511D8AEF.8040202@websitemanagers.com.au> <80A5C958-6E76-49BD-9CDC-3E8705B401C5@colorremedies.com> <511DB326.1090406@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511DB326.1090406@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
List-Id: linux-raid.ids


On Feb 14, 2013, at 9:01 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:

> Would it be a sequence like this:
> fdisk /dev/sdb
> d <- delete the existing partition
> u <- change units
> n <- new partition
> p <- primary
> 1 <- partition 1
> 64 <- start sector 64
> xxx <- end size of partition
> 
> Will that make it right?

Yes.

Chris Murphy