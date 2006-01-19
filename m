From: dean gaudet <dean@arctic.org>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 00:01:10 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0601182338560.29932@twinlark.arctic.org>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru>
 <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru>
 <20060117160829.GA16606@lug.udel.edu> <43CD3388.9050107@tls.msk.ru>
 <20060118081407.GC18945@localhost.localdomain> <43CE3898.7090207@xs4all.nl>
 <Pine.LNX.4.56.0601181248460.19220@lion.drogon.net> <17358.54414.410350.594083@cse.unsw.edu.au>
 <op.s3l6o9krcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s3l6o9krcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: Neil Brown <neilb@suse.de>, Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Jan 2006, PFC wrote:

> 	This isn't really a md issue, but it's really annoying only when using
> RAID, because it makes a normal process (kicking a dead drive out) so slow
> it's almost non-functional. Is there a way to modify the timeout in question ?

yeah i posted to l-k about similar problems a while back... i've got a 
disk which boots fine but fails all writes... useful for showing just how 
bad the system can become with a dead/dying disk.

western digital is selling "raid edition" disks now -- and part of their 
marketing material discusses the long timeout which commodity disks 
implement <http://www.westerndigital.com/en/library/sata/2579-001098.pdf>.  
the raid edition disks give up earlier on the assumption the raid layer is 
going to take care of things.  it's really too bad this isn't just a 
tunable parameter of the disk.

even still -- the linux kernel could probably do something about this... 
drivers could have a blockdev(8) tunable timeout, and a mode where the 
driver just gives up entirely on the device at the first error/timeout and 
return EIO for all outstanding requests at that point... and the driver 
could remain in this state until an explicit request to re-attempt normal 
operations.

-dean
