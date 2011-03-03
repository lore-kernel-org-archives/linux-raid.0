From: Lasse Jensen <fafler@gmail.com>
Subject: Re: Assembling RAID 5 array with missing superblock
Date: Thu, 3 Mar 2011 07:50:26 +0100
Message-ID: <AANLkTin8SxVSjUWNAQdmfixYN=Cm_5riAUE37ikGssAO@mail.gmail.com>
References: <AANLkTinfMUaLOVHBh0ZXFmHs353u==XkbGYtM8MPNkh8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinfMUaLOVHBh0ZXFmHs353u==XkbGYtM8MPNkh8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So should I just bite it and build a new array? All the really
important stuff is backed up elsewhere, the rest is, well, just crap i
got of the Internet, you know...

One last thing, I've been thinking about. What copying the superblock
from one of the working drives to the defect one and using a hew
editor to change the drive number and alignment? Is there much device
specific data in the superblock?

On Wed, Feb 23, 2011 at 3:05 PM, Lasse Jensen <fafler@gmail.com> wrote:
> I just keep having bad luck with my RAID 5 array. One drive (out of 4
> WD15EARS drives) was dropped from the array due to powerfailure and
> rebuild failed because of bad sectors on another drive. I have been
> spending the last few days with ddrescue, copying the data from the
> drive with bad sectors to the dropped one. The problem is now that the
> drive has bad sectors have spread where the md superblock used to be
> on the faulty drive (the very last sectors of the drive, right?), so
> how do i force it to assemble without it and with one drive missing?
>
> What drives are by the way the best consumer grade drives to use for
> RAID operation?
>
> I really, really hope this is the last time i need to ask you guys for help.
>
> --
> Lasse Jensen (fafler at gmail dot com)
>



-- 
Lasse Jensen (fafler at gmail dot com)
