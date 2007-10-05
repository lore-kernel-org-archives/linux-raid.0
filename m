From: "John Stoffel" <john@stoffel.org>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 15:02:22 -0400
Message-ID: <18182.35390.419883.646409@stoffel.org>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
	<20071004150831.6edbf926@zeus.pccl.info>
	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
	<Pine.LNX.4.64.0710041009530.8275@p34.internal.lan>
	<20071004154441.31addcfe@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071004154441.31addcfe@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Andrew" == Andrew Clayton <andrew@digital-domain.net> writes:

Andrew> On Thu, 4 Oct 2007 10:10:02 -0400 (EDT), Justin Piszcz wrote:


>> Also, did performance just go to crap one day or was it gradual?

Andrew> IIRC I just noticed one day that firefox and vim was
Andrew> stalling. That was back in February/March I think. At the time
Andrew> the server was running a 2.6.18 kernel, since then I've tried
Andrew> a few kernels in between that and currently 2.6.23-rc9

Andrew> Something seems to be periodically causing a lot of activity
Andrew> that max's out the stripe_cache for a few seconds (when I was
Andrew> trying to look with blktrace, it seemed pdflush was doing a
Andrew> lot of activity during this time).
 
Andrew> What I had noticed just recently was when I was the only one
Andrew> doing IO on the server (no NFS running and I was logged in at
Andrew> the console) even just patching the kernel was crawling to a
Andrew> halt.

How much memory does this system have?  Have you checked the output of
/proc/mtrr at all?  There' have been reports of systems with a bad
BIOS that gets the memory map wrong, causing access to memory to slow
down drastically.

So if you have 2gb of RAM, try booting with mem=1900m or something
like that and seeing if things are better for you.

Make sure your BIOS is upto the latest level as well.

John
