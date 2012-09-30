From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Sun, 30 Sep 2012 12:04:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se>
References: <loom.20120930T105755-205@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20120930T105755-205@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ <ej@ejane.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 30 Sep 2012, EJ wrote:

> Fast forward to now, I've upgraded the system to 12.04 LTS and have lost 
> access to my array. The array itself is a nine (9) disk raid6 managed by 
> mdadm.

What version of kernel for 12.04 were you running?

If you didn't upgrade your kernel, you might have been hit by the bug 
described in:

<http://neil.brown.name/blog/20120615073245>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
