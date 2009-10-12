From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 07:40:23 +1300
Message-ID: <4AD37817.1000902@sauce.co.nz>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman wrote:
> Hi... in recent tests we are seeing a 50% drop in performance from
> XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)

I can very loosely (based on very early testing and slightly different 
hardware) agree.

A couple of 2.6.27.19-78.2.30.fc9.x86_64 machines - 8GB RAM LSI SAS 
controller and 16 x WD RE3 750GB SATA md RAID6.

With stripe cache set to 16384, I see dd writes of 590MB/s.

Started testing a similar machine yesterday - 12GB RAM LSI SAS 
controller and 16 x WD RE3 1TB SATA md RAID6.

With stripe cache set to 16384, I see dd writes of around 290MB/s and 
when bumped up to 32768 (the maximum), it increases to 407MB.

Read performance is about the same as the older system - around 960MB/s.

Both systems are using XFS with an external journal.

As I say, early days - I've not compared scheduler etc. settings between 
kernels, but somewhatr disappointing.

Regards,

Richard

