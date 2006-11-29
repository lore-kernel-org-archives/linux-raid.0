From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --assemble weirdness?
Date: Wed, 29 Nov 2006 13:15:57 +1100
Message-ID: <17772.60765.661612.780701@cse.unsw.edu.au>
References: <1162293818.32109.113.camel@kenny>
	<17735.14472.835153.186432@cse.unsw.edu.au>
	<456CE109.7000202@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Patrik Jonsson on Tuesday November 28
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 28, patrik@ucolick.org wrote:
> Hi,
> 
> I just got a new SATA controller and moved some of my drives around, so
> the device numbers of course got all messed up. I expected mdadm to be
> able to handle that, which it did when I moved one device. However, when
> I moved the next 3, things got weird. Here's the output from mdadm
> --assemble --scan -v:
> 
> ... <removed unmatching devices>
--snip--
> mdadm: /dev/md5 assembled from 7 drives - not enough to start the array.
> 
> The added drives are the correct ones, but how it adds 10 drives but
> then thinks that it's only assembled 7 mystifies me. Is this a bug?

Weird...

What version of mdadm?

Can you show us "mdadm --examine" of a couple of devices?

Any kernel logs while this is happening?

NeilBrown
