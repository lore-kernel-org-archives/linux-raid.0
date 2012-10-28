From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 22:21:40 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1210282217230.28593@uplift.swm.pp.se>
References: <11510711257.20121028131527@oudeis.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1545639286-1351459300=:28593"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11510711257.20121028131527@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1545639286-1351459300=:28593
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 28 Oct 2012, Rainer Fügenstein wrote:

> what is your experience with 3TB drives, WD and others?

I have some experience with the 2TB Green drives, the ones I bought right 
after launch had a very high failure rate, the ones I got as replacement 
and purchased 6-12 months after launch, have fared a lot better.

I am however replacing them now with WD Red drives (only one so far, had 
my first failure in a year a few months back). The raid resync went very 
smoothly, I had constant 130 megabyte/s write speed to that 2TB Red drive 
during the resync.

As for people still talking RAID5 for these sized drives, I don't 
understand anyone not running RAID6. The rated read error rate on the 
drives are frightening (10^-14), so with single drive failure and doing 
resync, it's not uncommon to get read errors. RAID6 is definitely 
recommended.

<www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1545639286-1351459300=:28593--
