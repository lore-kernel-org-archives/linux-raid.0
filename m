From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 08:34:14 -0500
Message-ID: <4D5E7556.803@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5BD678.2050200@gmail.com>	<4D5BE119.7000804@turmel.org>	<4D5C0E17.3060306@gmail.com>	<4D5C140F.9010301@turmel.org>	<4D5C1508.3040308@gmail.com>	<4D5C15D3.1070608@turmel.org>	<4D5C167C.7000101@turmel.org>	<4D5C1CF8.1020507@gmail.com>	<4D5C1E0B.9060300@turmel.org>	<4D5C2061.4060106@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org>	<AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>	<4D5E7123.5020103@turmel.org> <AANLkTi=Yn4wWzRR2huY0asTHB8brcgF8PCkpvtrqmQBK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Yn4wWzRR2huY0asTHB8brcgF8PCkpvtrqmQBK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/18/2011 08:29 AM, Simon Mcnair wrote:
> top - 13:28:45 up 1 day, 39 min, 12 users,  load average: 2.65, 2.49, 2.37
> Tasks: 340 total,   7 running, 333 sleeping,   0 stopped,   0 zombie
> Cpu0  : 47.9%us, 15.0%sy,  0.0%ni, 13.7%id, 21.5%wa,  0.0%hi,  2.0%si,  0.0%st
> Cpu1  : 54.8%us,  8.7%sy,  0.0%ni, 33.3%id,  3.2%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu2  : 46.5%us, 13.7%sy,  0.0%ni, 37.9%id,  1.9%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu3  : 49.5%us,  9.5%sy,  0.0%ni, 37.6%id,  3.4%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu4  : 48.7%us,  8.2%sy,  0.0%ni, 17.3%id, 25.5%wa,  0.0%hi,  0.3%si,  0.0%st
> Cpu5  : 50.3%us,  7.2%sy,  0.0%ni, 41.8%id,  0.6%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu6  : 53.5%us,  6.6%sy,  0.0%ni, 38.4%id,  1.6%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu7  : 52.0%us,  6.2%sy,  0.0%ni, 41.2%id,  0.6%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:  12299244k total, 12227064k used,    72180k free, 10754600k buffers
> Swap: 11534332k total,        0k used, 11534332k free,   175916k cached

Hmmm.  Not what I expected at all.

I'd be very interested in some performance tests of the Supermicro ports vs. motherboard ports on that system.

Phil
