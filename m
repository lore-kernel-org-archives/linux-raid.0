From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 17:03:34 -0700
Message-ID: <472674D6.5030703@amfes.com>
References: <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>	 <1193294406.10336.76.camel@firewall.xsintricity.com>	 <472576A5.3030603@amfes.com> <20071029081802.GB15475@percy.comedia.it>	 <1193672839.10336.443.camel@firewall.xsintricity.com>	 <20071029212927.GA24635@percy.comedia.it> <1193699701.10336.508.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193699701.10336.508.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> Nah.  Even if we had concluded that udev was to blame here, I'm not
> entirely certain that we hadn't left Daniel with the impression that we
> suspected it versus blamed it, so reiterating it doesn't hurt.  And I'm
> sure no one has given him a fix for the problem (although Neil did
> request a change that will give debug output, but not solve the
> problem), so not dropping it entirely would seem appropriate as well.
>   
I've opened a bug report on Ubuntu's Launchpad.net.  Scott James Remnant 
asked me to cc him on Neil's incremental reference - we'll see what 
happens from here.

Thanks for the help guys.  At the moment, I've changed my mdadm.conf to 
explicitly list the drives, instead of the auto=partition parameter.  
We'll see what happens on the next reboot.

I don't know if it means anything, but I'm using a self-compiled 2.6.22 
kernel - with initrd.  At least I THINK I'm using initrd - I have an 
image, but I don't see an initrd line in my grub config.  Hmm....I'm 
going to add a stanza that includes the initrd and see what happens also.

-- 
Daniel
