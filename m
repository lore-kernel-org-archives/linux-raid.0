From: Werner Fischer <devlists@wefi.net>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 14:13:35 +0200
Message-ID: <1310991215.2417.93.camel@werner-t410>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	 <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de>
	 <alpine.OSX.2.00.1107181148590.8811@xavius.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1107181148590.8811@xavius.local>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2011-07-18 at 11:53 +0100, Tom De Mulder wrote:
> On Sun, 17 Jul 2011, Lutz Vieweg wrote:
> 
> > What is really an important factor for SSD performance: The controller.
> > The same SSDs perform with significantly lower latency for us when
> > connected to SATA controller channels than when connected to SAS
> > controllers (and they perform abysmal when used as hardware-RAID
> > constituents, in comparison).
> 
> Interesting.
> 
> I think it depends a lot on the controller. On a Dell server with PERC5/i 
> RAID controller (actually made by LSI) I saw some performance degradation 
> but not enough that I'd consider it a deal-breaker for situations where I 
> really cared about the RAID functionality, more than about the loss of 
> performance. After all, the latency is still massively lower than it is 
> with spinning disk.
> 
> I have a really great Areca RAID controller in a different server, but 
> unfortunately it's in use and it'll be a while before I get another one I 
> can use for testing. Given how well it does in other respects, I have high 
> hopes for it.

I agree that the controller can influence performance:
1. SATA controller: direct communication
2. SAS controller: Serial ATA Tunneling Protocol (STP) is used,
   this can have an impact on performance
3. Hardware RAID controller: depending on the controller, performance 
   impact can be from low to very high

Regards,
Werner

> 
> 
> Best,
> 
> --
> Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
> +44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
> -> 18/07/2011 : The Moon is Waning Gibbous (83% of Full)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
: Werner Fischer
: Technology Specialist
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki

