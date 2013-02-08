From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Fri, 8 Feb 2013 01:34:04 -0700
Message-ID: <A48D2760-7317-475D-9A95-27DCD8C47DBD@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com> <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com> <37E3C429-0A78-4DAE-BD2C-F23CF931BD91@colorremedies.com> <51149A66.6000308@websitemanagers.com.au> <DFB376BB-32B9-48DE-A7E9-A1B8F97982EF@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DFB376BB-32B9-48DE-A7E9-A1B8F97982EF@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 8, 2013, at 12:35 AM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> I'm flummoxed off hand if an NTFS formatted iSCSI block device behaves exactly as an NTFS formatted LV; 

The answer depends on whether you formatted the iSCSI target directly or partitioned it, then formatted the partition. If the latter, use kpartx -av to make the partition available under /dev/mapper and then you mount the device kpartx returns. Anyway the point was to run benchmarks on these; but if you have space in the VG you can make new (smaller) LVs for this, it's slightly safer.

I'd benchmark one LV as a reference. Then two simultaneously. Then three. I think the more basic the test for now the better or there's just too much data. Then I'd do that same test on physical servers, over iSCSI (one, two, then three simultaneous targets). Then do that same test within a VM, over iSCSI.

Trust Stan and Phil on this more than me. I just think something appallingly obvious will materialize with simple tests, and then you can dig down deeper with more specific tests.

First though, sort out this write error business. That bugs me more than the benchmarking stuff. Client and server side write errors in an iSCSI context make me think of file system corruption, either the write error caused by file system corruption, or creating it.


Chris Murphy