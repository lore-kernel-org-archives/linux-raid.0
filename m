From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How-to for enabling TRIM for SSD RAID-1 arrays?
Date: Sat, 14 Sep 2013 09:04:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1309140902510.10009@uplift.swm.pp.se>
References: <CAD2NviVyoF4y9uQnvcng082zAGQoXq18JT7WM=+RfBGCzCp9zA@mail.gmail.com> <523397BE.8080404@hardwarefreak.com> <CAD2NviU0ptD9BUWnqVYsJsyi6e+8mffYSbWz+HDwdi721cq5gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAD2NviU0ptD9BUWnqVYsJsyi6e+8mffYSbWz+HDwdi721cq5gA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Derek Piper <derek.piper@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 Sep 2013, Derek Piper wrote:

> I have 2 Sandisk Extreme 120GB SSDs (Sandforce 2281 with latest
> firmware - R211). I have indeed heard that TRIM was desirable to limit
> the effects of write amplification and to keep the write performance
> to a good level throughout the life of the drive(s). This machine is a
> home file/print/web/mysql server (the real large data being on regular
> 7200RPM HDD RAID arrays). The SSDs are for boot, root and home
> directories.

You're most likely much better off by just using 80 gigs out of those 120 
gig drives (don't use all space for partition) to avoid write 
amplification.

TRIM has performance problems on some hardware (takes a long time per 
block), it's probably just better and easier to just keep blocks unused 
(never written to) and ignore TRIM.

https://en.wikipedia.org/wiki/Write_amplification#Over-provisioning

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
