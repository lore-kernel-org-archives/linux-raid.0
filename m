From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 array showing as degraded after motherboard replacement
Date: Tue, 07 Nov 2006 13:00:32 -0500
Message-ID: <4550C9C0.7060705@tmr.com>
References: <ef2613f30611050858m562386a0m7966667f803f35fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2613f30611050858m562386a0m7966667f803f35fc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Lee <james.lee@cantab.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Lee wrote:

> Hi there,
>
> I'm running a 5-drive software RAID5 array across two controllers.
> The motherboard in that PC recently died - I sent the board back for
> RMA.  When I refitted the motherboard, connected up all the drives,
> and booted up I found that the array was being reported as degraded
> (though all the data on it is intact).  I have 4 drives on the on
> board controller and 1 drive on an XFX Revo 64 SATA controller card.
> The drive which is being reported as not being in the array is the one
> connected to the XFX controller.
>
> The OS can see that drive fine, and "mdadm --examine" on that drive
> shows that it is part of the array and that there are 5 active devices
> in the array.  Doing "mdadm --examine" on one of the other four drives
> shows that the array has 4 active drives and one failed.  "mdadm
> --detail" for the array also shows 4 active and one failed.
>
> Now I haven't lost any data here and I know I can just force a resync
> of the array which is fine.  However I'm concerned about how this has
> happened.  One worry is that the XFX SATA controller is doing
> something funny to the drive.  I've noticed that it's BIOS has
> defaulted to RAID0 mode (even though there's only one drive on it) - I
> can't see how this would cause any particular problems here though.  I
> guess it's possible that some data on the drive got corrupted when the
> motherboard failed... 

I notice in your later post that the driver thinks this is a JBOD setup, 
can you either tell the controller to JBOD or force the driver to 
consider this a RAID0 single disk setup? I don't know what RAID0 on one 
drive means, but I suspect that having the controller in the mode you 
want is desirable. That might have been changed in the hardware failure.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


