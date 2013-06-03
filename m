From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID-10 keeps aborting
Date: Mon, 3 Jun 2013 12:09:33 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1306031200230.25158@jlaw-desktop.mno.stratus.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51ACBAA0.40604@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 3 Jun 2013, H. Peter Anvin wrote:

> On 06/02/2013 11:14 PM, Dan Williams wrote:
> > 
> > If I'm reading things correctly that may still result in failure since
> > md will still pass the REQ_WRITE_SAME bios down to the the devices and
> > will receive BLK_PREP_KILL for its trouble.  md only notices that
> > write same is disabled on underlying devices at assembly time.
> > 
> 
> I have to admit to not seeing where md (as opposed to dm) even looks for
> if the underlying devices have write same enabled.  It seems extremely
> likely that it is write same that is causing the headaches, though.

I'll try to take a look later, but for now maybe these threads could help 
you?

  http://thread.gmane.org/gmane.linux.raid/41035
  http://thread.gmane.org/gmane.linux.raid/41078

It might be that after commit 4363ac7 "block: Implement support for WRITE 
SAME", the max_write_same_sectors for the MD is set to the minimum its 
component disks (at least for RAID1).  Not sure exactly how RAID10 treats 
it, but maybe there are enough clues in that first thread to figure it 
out.

When I have some more time I can help investigate.

Regards,

-- Joe
