From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Highpoint 1820A
Date: Sun, 18 Sep 2005 21:13:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0509182110110.21650@uplift.swm.pp.se>
References: <Pine.LNX.4.62.0509170714560.21650@uplift.swm.pp.se>
 <432D2D92.3090804@dtbb.net> <432DA126.6070206@naa.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="918750597-9887249-1127070789=:21650"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <432DA126.6070206@naa.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--918750597-9887249-1127070789=:21650
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 18 Sep 2005, Norman Schmidt wrote:

> So it doesn´t work without drivers and changing the kernel (at least 
> that´s what Highpoint thinks).

Quite. I had to compile a standard kernel (2.6.11.12 in my case) which I 
tried everything on.

The HPT driver for the 1820A won't compile on 2.6.13 because something was 
depreciated that they're using in their driver.

I wish I knew all this before I bought the unit. The 1820A is a nicely 
priced unit, too bad it doesn't seem to work well under linux.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
--918750597-9887249-1127070789=:21650--
