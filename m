From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Software vs. Hardware RAID
Date: Tue, 3 Aug 2004 11:58:45 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0408031152380.25702-100000@sweetums.bluetronic.net>
References: <410F7B65.3090407@buttersideup.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <410F7B65.3090407@buttersideup.com>
To: Tim Small <tim@buttersideup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Aug 2004, Tim Small wrote:
>This may catch blocks which are going bad before they become unreadable
>(i.e. when the hardware and/or firmware ECC algorithms are still able to
>reconstruct the data), and cause the drive to silently remap these
>blocks - so these may well save you an array degradation...
...
>>- no bad block relocation (7/2004)
>Most drives will do this automatically, except in the event of data loss
...

Don't bet the farm on IDE drives remapping bad sectors.  There are two
Seagate drives on my desk that claim to have remapped the bad sectors
but still return errors for those sectors. (both via the seatools DOS
thing and Linux zeroing the entire (200G) drive.)

Remember: You get what you pay for.

Maybe we should start a class action suit to get SCSI prices down :-)

--Ricky


