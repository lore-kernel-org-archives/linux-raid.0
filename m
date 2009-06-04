From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
Date: Thu, 4 Jun 2009 10:00:48 +0100
Message-ID: <7D1FEDD3-43D1-4CDB-9F60-0FFBFC7B08EB@cam.ac.uk>
References: <18980.48553.328662.80987@notabene.brown> <4A25876A.1010901@garzik.org> <18981.62579.171350.910761@notabene.brown> <448D5698-81A1-4100-8AF5-B6660D96ECE9@cam.ac.uk> <18983.97.262909.30692@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18983.97.262909.30692@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On 3 Jun 2009, at 23:59, Neil Brown wrote:
> [Cc list trimmed as this is more of a focused technical issue]
>
> On Wednesday June 3, aia21@cam.ac.uk wrote:
>> Hi Neil,
>>
>> Is there any documentation for the interface between mdadm and a
>> metadata format "module" (if I can call it that way)?
>>
>> What I mean is: where would one start if one wanted to add a new
>> metadata format to mdadm?
>
> You would start looking in mdadm.h at the "struct superswitch".
> This lists a both of inter points for the metadata module.
> The intent of some should be obvious from the name.  Others
> come with a little bit of documentation.
>
> I'd be very happy to flesh this documentation out now that the
> interface has (hopefully) stablised.   If you could help by asking
> focussed questions that I could answer by improving the comments, that
> would be a big help.
>
>> Or is the only documentation the source code to mdadm?
>
> The final arbiter is certainly the source code, and I often have to
> check the actual call patterns myself to be sure.  But I think it is
> time to start tidying this up.


Great, thanks for the pointers!  I will take a look soon.

btw. The reason I am interested is for LDM which we currently support  
in the kernel but we do not do any of the glueing together of raid  
arrays we just expose the components as individual devices.  It would  
be nice to remove the kernel driver completely and instead have the  
detection done in user space and let the MD driver do the actual  
mirroring/striping/raid5 work...  I have always meant to use dmraid to  
do it but never got round to it as it does not support raid5 so it  
would never have been a complete solution for LDM.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

