From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 12:45:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
References: <18200.49267.763509.924873@stoffel.org>
 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan> <18200.53593.687483.120827@stoffel.org>
 <1192810534.1666.68.camel@firewall.xsintricity.com> <18200.56684.14194.630264@stoffel.org>
 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan> <18200.57042.989520.666476@stoffel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18200.57042.989520.666476@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 19 Oct 2007, John Stoffel wrote:

>>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>
> Justin> Is a bitmap created by default with 1.x?  I remember seeing
> Justin> reports of 15-30% performance degradation using a bitmap on a
> Justin> RAID5 with 1.x.
>
> Not according to the mdadm man page.  I'd probably give up that
> performance if it meant that re-syncing an array went much faster
> after a crash.
>
> I certainly use it on my RAID1 setup on my home machine.
>
> John
>

The performance AFTER a crash yes, but in general usage I remember seeing 
someone here doing benchmarks it had a negative affect on performance.

Justin.
