From: Neil Brown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
Date: Thu, 4 Jun 2009 08:59:45 +1000
Message-ID: <18983.97.262909.30692@notabene.brown>
References: <18980.48553.328662.80987@notabene.brown>
	<4A25876A.1010901@garzik.org>
	<18981.62579.171350.910761@notabene.brown>
	<448D5698-81A1-4100-8AF5-B6660D96ECE9@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Anton Altaparmakov on Wednesday June 3
Sender: linux-raid-owner@vger.kernel.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


[Cc list trimmed as this is more of a focused technical issue]

On Wednesday June 3, aia21@cam.ac.uk wrote:
> Hi Neil,
> 
> Is there any documentation for the interface between mdadm and a  
> metadata format "module" (if I can call it that way)?
> 
> What I mean is: where would one start if one wanted to add a new  
> metadata format to mdadm?

You would start looking in mdadm.h at the "struct superswitch".
This lists a both of inter points for the metadata module.
The intent of some should be obvious from the name.  Others
come with a little bit of documentation.

I'd be very happy to flesh this documentation out now that the
interface has (hopefully) stablised.   If you could help by asking
focussed questions that I could answer by improving the comments, that
would be a big help.

> 
> Or is the only documentation the source code to mdadm?

The final arbiter is certainly the source code, and I often have to
check the actual call patterns myself to be sure.  But I think it is
time to start tidying this up.

Thanks,
NeilBrown


> 
> Thanks a lot in advance!
> 
> Best regards,
> 
> 	Anton
> -- 
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
