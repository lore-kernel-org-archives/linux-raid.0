From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 07:26:03 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301200720010.12098@uplift.swm.pp.se>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
 <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <50FB22D8.5000803@hardwarefreak.com> <50FB3185.7060009@ultratux.net>
 <6675858F-43FC-48CE-B146-856F50481289@colorremedies.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6675858F-43FC-48CE-B146-856F50481289@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Maarten <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Jan 2013, Chris Murphy wrote:

> Please explain this basic, simple math, where a URE is equivalent to 1 
> bit of information. And also, explain the simple math where bit of error 
> is equal to a URE. And please explain the simple math in the context of 
> a conventional HDD 512 byte sector, which is 4096 bits.
>
> If you have a URE, you have lost not 1 bit. You have lost 4096 bits. A 
> loss of 4096 bits in 12.5TB (not 12.5TiB) is an error rate of 1 bit of 
> error in 2.44^10 bits. That is a gross difference from published error 
> rates.

I have seen your point of view posted in other discussions, and I don't 
buy it. I believe the manufacturers are talking about how many bits read 
before there is one or more bit error (ie can't error correct the bit 
errors on that sector, so now the whole sector is URE. Since the sector is 
an atomic unit, the drive can't report a single bit error (even though 
that's probably what it is), it'll URE the whole 4k bytes. The 
manufacturer is still talking about what's on the platter, not what the OS 
sees.

Your view on how this works would mean that drives would read more than 
10^3 more data before an URE, which from my empirical data isn't right. 
Also, for a 4k sector drive, with your logic, would have 8 times better 
BER ratio which I don't believe either.

I believe Phil was spot on when it comes to how it works. His post "19 Jan 
2013 18:53:41" is exactly how I believe things work.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
