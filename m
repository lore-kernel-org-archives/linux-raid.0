From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: On URE and RAID rebuild - again!
Date: Wed, 30 Jul 2014 15:05:29 +0200
Message-ID: <53D8ED99.90606@assyoma.it>
References: <53D8ACF0.1070202@assyoma.it> <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

On 30/07/2014 13:13, Mikael Abrahamsson wrote:
>
> There has been much discussion about the URE figures. Some people
> interpret it one way, others another way. There is nobody here that
> knows for sure. Ask your HDD vendor, if they answer, do share here!
>
- Ouch! -
I was hoping that HDD vendors were somewhat more open about their URE 
calculations... It's time for some lab test, I think!
 >
> When MD encounters an URE, it should calculate that block from parity
> information and write it. I have personally had problems with this not
> happening, seems it might be that if the URE doesn't happen repeatedly,
> MD might not re-write. All parity raid levels should behave the same, so
> this should work identically for RAID1, RAID10, RAID5 and RAID6.
>
What about _degraded_ array state? In other words, if a degraded RAID5 
experiences a URE during rebuild, what happens? I read that most 
hardware based RAID card both stop rebuilding _and_ kill the entire 
array. From my understanding, mdadm should stop rebuilding but the array 
can the restarted, mounted and backupped. Right?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
