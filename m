From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Roadmap for md/raid ???
Date: Tue, 30 Dec 2008 19:12:50 +0100
Message-ID: <20081230191250.70701c5c@absurd>
References: <18763.7881.300921.177207@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18763.7881.300921.177207@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown said:     (by the date of Fri, 19 Dec 2008 15:10:49 +1100)

> - raid5->raid6 conversion.
>    This is also a fairly commonly asked for feature.

I can be one of the first ones to test that :)

In my raid5 home backup server I had two failures in one month.
First a SATA cable of one drive stopped working, and few weeks 
later another drive died (hdc: DMA timeout error - ad infinitum,
and system stopped responding - trying to read that drive;
also smartctl was reporting errors constantly).

BTW: I thought that smartctl and mdadm were cooperating together to
find out about damaged drives, but apparently it's not the case.

Now I feel so uneasy now with this raid5, that I'm going to switch into
raid6 ASAP.

-- 
Janek Kozicki                                                         |
