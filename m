From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sun, 31 Jan 2010 16:17:09 +0000
Message-ID: <4B65AD05.5050000@anonymous.org.uk>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/01/2010 21:33, Mikael Abrahamsson wrote:
[...]
> I think the 4k sector size on WD20EARS (for instance) is supposed to add 
> more ECC information but I'm not sure how this will affect the 10^14 
> error rate.

iirc part of the point of moving to 4K sectors is to improve the error 
correction to something like 1 in 10^20 or 22 without losing storage 
density, partly by using what was lost before in inter-sector gaps and 
partly because you can do better with more bits of ECC over more data.

Frankly I wish they'd sacrificed a little storage density and improved 
the error rate a long time ago.

Cheers,

John.

