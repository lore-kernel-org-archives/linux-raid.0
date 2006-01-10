From: PFC <lists@peufeu.com>
Subject: Re: Kanotix crashed my raid... (nvidia crashed my raid...)
Date: Tue, 10 Jan 2006 10:54:27 +0100
Message-ID: <op.s25ps1wxcigqcu@apollo13>
References: <200601100159.15576.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601100159.15576.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> So far ok for a few days. The promise cards are 54-62 dollars with 4
> controllers. they work with kernel 2.6.12 and 2.6.14 debian stock  
> kernels.
> via controllers on motherboard are good too - so far. i will let you  
> know more
> over time.

	Well. The linux box is holding.
	The windows box won't even boot now. When it worked, it had actually  
reverted the SATA in PIO mode (event log says "too many errors, reverting  
back to PIO". Ouch. I put back DMA and now, this PC is a doorstop. Need I  
say the HDD is new and perfectly functional ?

	Which means I can't even backup my linux data using the windows box,  
because my backup hdd is SATA !!!!

	So I'm going to either change the mobo (but I'll never be able to get a  
RMA on this), or buy the promise sata card you speak about. So I'll have a  
Mobo with 4 unused sata ports. Cool.

	google, read this : nvidia nforce sata software raid does not work with  
maxtor HDDs !!!

http://forums.nvidia.com/lofiversion/index.php?t900.html
http://forums.nvidia.com/index.php?showtopic=2497
http://forums.nvidia.com/index.php?showtopic=2972

another guy who has the exact same error messages as I (on Mandriva) (in  
french) :

http://www.thisishull.net/archive/index.php/t-140129.html

a patch that I did not try :

http://www.thisishull.net/archive/index.php/t-140129.html
