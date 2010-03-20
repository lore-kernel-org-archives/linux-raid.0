From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: OT: sas controllers/expanders and "desktop" drives?
Date: Sun, 21 Mar 2010 08:24:31 +1300
Message-ID: <4BA520EF.2030600@sauce.co.nz>
References: <20100317143602.GA18298@septictank.raw-sewage.fake> <4BA4EAFB.1050302@tmr.com> <20100320164748.GA31221@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100320164748.GA31221@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Garman wrote:

> As for RAID usage (md or hardware): just to be clear, my
> understanding is that the biggest problem is that, even if the
> desktop drives work fine for non-RAID use, they'll still be
> "difficult" in an array.  That is, they take too long to report
> errors, and thus get kicked out of the array.

Another important, (from a performance perspective), feature of the 
enterprise drives which will be factor in your setup, is that they are 
optimised for use in a high vibration environment (RAFF in Western 
Digital parlance), unlike desktop drives.

The following illustrates the problem in a somewhat humourous way:

http://www.youtube.com/watch?v=tDacjrSCeq4

While the desktop drives will work, throughput and seek times may be 
compromised due to vibration and resonance effects from many drives in 
one enclosure.

Regards,

Richard
