From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: mismatch_cnt again
Date: Sun, 8 Nov 2009 17:04:33 +0100
Message-ID: <20091108160433.GA5338@lazy.lzy>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com> <4AF5268D.60900@eyal.emu.id.au> <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com> <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com> <87iqdlaujb.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87iqdlaujb.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> But unless your drive firmware is broken the drive with only ever give
> the correct data or an error. Smart has a counter for blocks that have
> gone bad and will be fixed pending a write to them:
> Current_Pending_Sector.
> 
> The only way the drive should be able to give you bad data is if
> multiple bits toggle in such a way that the ECC still fits.

Not really, I've disks which are *perfect* in smart sense
and nevertheless I had mistmatch count.
This was a SW problem, I think now fixed, in RAID-10 code.

This means that, yes, there could be mismatches, without
any warning, from other sources than disks.
And these could be anywhere in the system.
I already mentioned, time ago, a cabling problem which was
leading to a similar result: wrong data on different disks,
without any warning or error from the HW layer.

That is why it is important to know *where* the mismatch
occurs and, if possible, in which device component.
If it is an empty part of the FS, no problem, if it
belongs to a specific file, then it would be possible
to restore/recreate it.

Of course, a tool will be needed telling which file is
using a certain block of the device.

bye,

-- 

piergiorgio
