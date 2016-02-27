From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Recovering failed raid6 with 3 failing devices.
Date: Sat, 27 Feb 2016 19:00:52 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1602271859250.11524@uplift.swm.pp.se>
References: <1E25F099-6730-4A26-9805-C5F547B42276@vandalon.nl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1739484423-1456596052=:11524"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1E25F099-6730-4A26-9805-C5F547B42276@vandalon.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Vandalon <joris@vandalon.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1739484423-1456596052=:11524
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 24 Feb 2016, Vandalon wrote:

> Hi,
>
> I am trying to recover a 10 disk raid6-set, but to no succes.
>
> After reading https://raid.wiki.kernel.org/index.php/RAID_Recovery, I tried the following but the —force option does not seem to work:
>
> and using mdadm - v3.3 - 3rd September 2013

Compile mdadm from latest git resource and try again.

If that doesn't work, post full mdadm -E from all drives so we can see 
what's actually going on, I'd imagine it's not only the event count that's 
preventing these drives frmo being used.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1739484423-1456596052=:11524--
