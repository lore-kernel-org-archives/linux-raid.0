From: "Andrew Rechenberg Lists" <flux-ml@resurgent.com>
Subject: RE: RAID10 vs. LVM on RAID1
Date: Tue, 23 Aug 2005 13:46:41 -0400
Message-ID: <E3B0B2160F552B408D3655883F58C144040FEF@cinshrexc02.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

We actually use both RAID10 and LVM.  It's on a 2.4 kernel so we're not
using device mapper, however it gives us the performance we want along
with the LVM disk management and snapshot abilities.

LVM gets a little cranky though so I had to muck with the initscripts.
Other than that little detail, it works great for us:

52 SCSI disk + 4 hot spares in RAID10 with LVM on top of the RAID10
array.

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of John McMonagle
> Sent: Tuesday, August 23, 2005 11:47 AM
> To: gsslist+linuxraid@anthropohedron.net
> Cc: Linux RAID list
> Subject: Re: RAID10 vs. LVM on RAID1
> 
> I did lvm over 2 raid 1 arrays recently.
> 
> Running dd on the lv gives about 3 times  the  drive speed.
> Should be 4 times .
> I hate to give up performance but I'm willing to live with it 
> as lvm makes disk management so much easier.
> 
> John
>  
> 
> 
> 
> 
> Gregory Seidman wrote:
> 
> >Is there any advantage to RAID10 over creating an LVM volume group 
> >across the same number of RAID1 pairs? LVM does striping, 
> after all. Am 
> >I overlooking something?
> >
> >--Greg
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" 
> >in the body of a message to majordomo@vger.kernel.org More majordomo 
> >info at  http://vger.kernel.org/majordomo-info.html
> >  
> >
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
Confidentiality Notice: This e-mail message including attachments, if any, is intended
only for the person or entity to which it is addressed and may contain confidential
and/or privileged material. Any unauthorized review, use, disclosure or distribution
is prohibited. If you are not the intended recipient, please contact the sender by reply
e-mail and destroy all copies of the original message. If you are the intended recipient,
but do not wish to receive communications through this medium, please so advise the
sender immediately.


