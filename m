From: Christian Balzer <chibi@gol.com>
Subject: Re: Assembly failure
Date: Wed, 11 Jul 2012 17:27:42 +0900
Message-ID: <20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
References: <20120710163345.GB29855@nsrc.org>
	<4FFC5CC0.8050808@profitbricks.com>
	<20120710170646.GA29962@nsrc.org>
	<4FFC68AB.4010801@profitbricks.com>
	<20120710185927.GA30164@nsrc.org>
	<20120711124316.206ab3d9@notabene.brown>
	<20120711075818.GA30527@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711075818.GA30527@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Brian Candler <B.Candler@pobox.com>
List-Id: linux-raid.ids

On Wed, 11 Jul 2012 08:58:18 +0100 Brian Candler wrote:

[snip]
> 
> BTW these are all Seagate ST3000DM001. Yes, I know :-(
> 
Indeed, there is your problem. And on a LSI controller (which one?) to
boot. ^o^ 
Though the later part should be fine with a kernel as new as yours.

The new STxxxxM drives from Seagate are <expletive deleted>. 
They're wonderfully fast, but you absolutely can NOT use them in any HW
RAID until they get a non-braindead firmware that won't park (look at the
Load_Cycle_Count in SMART) the heads every 30 seconds, come rain or shine.
Not only will this wear out the drives in any remotely busy scenario, but
it will also cause them to be considered off-line by the SATA controller in
the right (wrong) circumstances, leading to exactly what you're seeing
here.
I experienced the same thing and have switched to Hitachi drives for the
foreseeable future, which seem from one year of experience to be of far
higher quality/reliability anyway.

These Seagates are also suffering from quality control issues and large DOA
and early death rates.

With direct attached drives that you can issue hdparm commands to, you can
"fix" this deadly behavior by issuing an "apm = 255" command to them (in
hdparm.conf, needs to be done on each boot...).

[snip]

Regards,

Christian
-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
