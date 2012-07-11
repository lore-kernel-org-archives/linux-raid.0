From: Christian Balzer <chibi@gol.com>
Subject: Re: Assembly failure
Date: Thu, 12 Jul 2012 02:21:29 +0900
Message-ID: <20120712022129.3c45303b@batzmaru.gol.ad.jp>
References: <20120710163345.GB29855@nsrc.org>
	<4FFC5CC0.8050808@profitbricks.com>
	<20120710170646.GA29962@nsrc.org>
	<4FFC68AB.4010801@profitbricks.com>
	<20120710185927.GA30164@nsrc.org>
	<20120711124316.206ab3d9@notabene.brown>
	<20120711075818.GA30527@nsrc.org>
	<20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
	<20120711164441.2790ac3b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711164441.2790ac3b@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org, Brian Candler <B.Candler@pobox.com>
List-Id: linux-raid.ids

On Wed, 11 Jul 2012 16:44:41 +0600 Roman Mamedov wrote:

> On Wed, 11 Jul 2012 17:27:42 +0900
> Christian Balzer <chibi@gol.com> wrote:
> 
> > RAID until they get a non-braindead firmware that won't park (look at
> > the Load_Cycle_Count in SMART) the heads every 30 seconds, come rain
> > or shine.
> 
> So I seem to have such firmware, what do I win?
> 
An inflatable washer machine...

> Device Model:     ST1000DM003-9YN162
> 
>   9 Power_On_Hours          0x0032   097   097   000    Old_age
> Always       -       2796 193 Load_Cycle_Count        0x0032   100
> 100   000    Old_age   Always       -       326
>
Read the respective threads on the Seagate forums.

If your drive is not busy most of the time, once the heads get parked
(unloaded), they will stay that way, until it gets accessed again.
However if the drive is busy every second or so, the aforementioned
statement holds. 

Device Model:     ST2000DM001-9YN164
Firmware Version: CC4C
193 Load_Cycle_Count        0x0032   099   099   000    Old_age   Always       -       2419

Those were accumulated in the first 2 days or so of that drive, before I
set the APM level to 255.

-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
