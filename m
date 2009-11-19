From: Neil Brown <neilb@suse.de>
Subject: Re: Raid10 & Rhel
Date: Thu, 19 Nov 2009 12:32:50 +1100
Message-ID: <20091119123250.5f0474e1@notabene.brown>
References: <20091118235110.GM1863@voyageur.mas.nom.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091118235110.GM1863@voyageur.mas.nom.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Erwan MAS <erwan@mas.nom.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Nov 2009 00:51:10 +0100
Erwan MAS <erwan@mas.nom.fr> wrote:

> Hello ,
> 
> I have found this bug in RehHat Bugzilla 
> 
> "md raid10 far layout resync corruption bug in rhel kernel
> 2.6.18-92.1.13.el5"
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=468379
> 
> 
> The bug is not very verbose .
> 
> Someone have more information ?
> 
> 

If you look in the kernel git history for that patch that is identified,
you find it comes with a comment as below.
Maybe that is the more information you want?  You aren't very specific.

NeilBrown

    [PATCH] md: fix raid10 recovery problem.
    
    There are two errors that can lead to recovery problems with raid10
    when used in 'far' more (not the default).
    
    Due to a '>' instead of '>=' the wrong block is located which would
    result in garbage being written to some random location, quite
    possible outside the range of the device, causing the newly
    reconstructed device to fail. 
    The device size calculation had some rounding errors (it didn't
    round when it should) and so recovery would go a few blocks too far
    which would again cause a write to a random block address and
    probably a device error. 
    The code for working with device sizes was fairly confused and
    spread out, so this has been tided up a bit.
    
