From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: feature suggestion to handle read errors during re-sync of
 raid5
Date: Sun, 31 Jan 2010 18:56:33 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se> <4B65AD05.5050000@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B65AD05.5050000@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 31 Jan 2010, John Robinson wrote:

> iirc part of the point of moving to 4K sectors is to improve the error 
> correction to something like 1 in 10^20 or 22 without losing storage 
> density, partly by using what was lost before in inter-sector gaps and 
> partly because you can do better with more bits of ECC over more data.
>
> Frankly I wish they'd sacrificed a little storage density and improved the 
> error rate a long time ago.

Looking at the data sheet for WD20EADS and WD20EARS they both have 10^15 
"non-recoverable read errors per bits read", so at least in the data sheet 
nothing has really changed in the error rate aspect.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
