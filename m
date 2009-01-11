From: Nifty Fedora Mitch <niftyfedora@niftyegg.com>
Subject: Re: [Benchmarks] How do I set the memory invalidate bit for a
	3ware 9550SXU-12 controller?
Date: Sun, 11 Jan 2009 11:27:42 -0800
Message-ID: <20090111192742.GA3784@compegg.wr.niftyegg.com>
References: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide-arrays@lists.math.uh.edu
List-Id: linux-raid.ids

On Thu, Jan 08, 2009 at 09:20:30AM -0500, Justin Piszcz wrote:
> Subject: [Benchmarks] How do I set the memory invalidate bit for a 3ware 9550SXU-12 controller?
> 
> System = RHEL5 x86_64
> Kernel = 2.6.18-53.1.13.el5
>
> Per: http://makarevitch.org/rant/raid/
> It states: "A potential culprit, at least for slow write operations, lies in Q12546. I played with setpci in order to enable this ''Memory Write and Invalidate' (lspci now shows that the 3Ware controller 9550 is in 'MemWINV+' instead of 'MemWINV-' mode), maybe enhancing write throughput. The 9650 is in 'MemWINV-' mode. This seems somewhat frequent with SuperMicro mainboards, check this with your system integrator or SuperMicro support service. This may be somewhat tied to the "interleaved memory". With the 9650 my PCI parameters are as follows:"
>
> Links to: http://www.3ware.com/KB/article.aspx?id=12546
>
> How do I change MemWINV+ to MemWINV- using setpci?

Since this is a SuperMicro motherboard double check the BIOS settings
involved with MTRR registers.  Since Windows uses PAT its drivers will often
ignore BIOS settings that Linux will not.


-- 
	T o m  M i t c h e l l 
	Found me a new hat, now what?

