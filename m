From: danci@agenda.si
Subject: Re: Is there any way to delay reconstruction
Date: Thu, 26 May 2005 08:48:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0505260841130.22131@desktop.agenda.si>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
 <Pine.LNX.4.62.0505250925360.6360@webhosting.rdsbv.ro>
 <Pine.LNX.4.61.0505251019280.16854@desktop.agenda.si> <429495C9.3090208@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429495C9.3090208@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 May 2005, Mike Hardy wrote:

> I've had this problem. I turned the raid speed limit max to 0, slept for
> a second (just because), did my hdparm commands, slept another second
> (again, just because - may not be necessary), then turned the raid speed
> limit back to something that was good for background reconstruction.
> 
> That got rid of my dropped interrupts

That's a good idea - why didn't I think of that! :)

Anyway, I've recompiled the kernel with piix NOT as a module and it 
works.

But maybe it would be easier to change the rc.boot script then reinstall 
the kernel - on the 800+ machines!?

Thanks for the idea!

 D.
