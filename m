From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 09:03:43 -0500
Message-ID: <B6E0BCA1-5F60-431F-8A29-9B36D3A05413@mac.com>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru> <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CCD453.9070900@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: sander@humilis.net, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Jan 17, 2006, at 06:26, Michael Tokarev wrote:
> This is about code complexity/bloat.  It's already complex enouth.  
> I rely on the stability of the linux softraid subsystem, and want  
> it to be reliable. Adding more features, especially non-trivial  
> ones, does not buy you bugfree raid subsystem, just the opposite:  
> it will have more chances to crash, to eat your data etc, and will  
> be harder in finding/fixing bugs.

What part of: "You will need to enable the experimental  
MD_RAID5_RESHAPE config option for this to work." isn't bvious?  If  
you don't want this feature, either don't turn on  
CONFIG_MD_RAID5_RESHAPE, or don't use the raid5 mdadm reshaping  
command.  This feature might be extremely useful for some people  
(including me on occasion), but I would not trust it even on my  
family's fileserver (let alone a corporate one) until it's been  
through several generations of testing and bugfixing.


Cheers,
Kyle Moffett

--
There is no way to make Linux robust with unreliable memory  
subsystems, sorry.  It would be like trying to make a human more  
robust with an unreliable O2 supply. Memory just has to work.
   -- Andi Kleen


