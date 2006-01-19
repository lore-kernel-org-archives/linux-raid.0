From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 11:28:05 +1100
Message-ID: <17358.56597.418773.34768@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43CCA80B.4020603@tls.msk.ru>
	<20060117095019.GA27262@localhost.localdomain>
	<43CCD453.9070900@tls.msk.ru>
	<B6E0BCA1-5F60-431F-8A29-9B36D3A05413@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kyle Moffett on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, sander@humilis.net, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Tuesday January 17, mrmacman_g4@mac.com wrote:
> On Jan 17, 2006, at 06:26, Michael Tokarev wrote:
> > This is about code complexity/bloat.  It's already complex enouth.  
> > I rely on the stability of the linux softraid subsystem, and want  
> > it to be reliable. Adding more features, especially non-trivial  
> > ones, does not buy you bugfree raid subsystem, just the opposite:  
> > it will have more chances to crash, to eat your data etc, and will  
> > be harder in finding/fixing bugs.
> 
> What part of: "You will need to enable the experimental  
> MD_RAID5_RESHAPE config option for this to work." isn't bvious?  If  
> you don't want this feature, either don't turn on  
> CONFIG_MD_RAID5_RESHAPE, or don't use the raid5 mdadm reshaping  
> command.

This isn't really a fair comment.  CONFIG_MD_RAID5_RESHAPE just
enables the code.  All the code is included whether this config option
is set or not.  So if code-bloat were an issue, the config option
wouldn't answer it.

NeilBrown
