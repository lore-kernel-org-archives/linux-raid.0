From: Evan Felix <evan.felix@pnl.gov>
Subject: Re: 3ware JBOD
Date: Mon, 01 Mar 2004 12:50:20 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1078174220.3010.13.camel@e-linux>
References: <40429940.9000408@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <40429940.9000408@sauce.co.nz>
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You will have to look In the bios setup screens to make sure all the
drives are in the 'Available Drives' Section.  If I remember right they
have to be here to show up in linux as separate drives.

It may be holding the drives as 'previously used' and not as availible.

These options may be different as I think we have different Cards than
you.  

Evan

On Sun, 2004-02-29 at 18:00, Richard Scobie wrote:
> I have a 3ware 7506-4LP with 4 x 250 which when first installed showed 
> up in the system as SCSI devices sda-d.
> 
> I built and tested various software RAID arrays on it, then decided to 
> try various hardware arrays, which tested fine.
> 
> Wishing to go back and build some more linux software arrays, I used the 
> 3ware CLI utility to delete the array.
> 
> Now, when I boot up, although all 4 drives show up in the 3ware BIOS, 
> dmesg now shows:
> 
> SCSI subsystem driver Revision: 1.00
> 3ware Storage Controller device driver for Linux v1.02.00.037.
> 3w-xxxx: No valid units for card 0.
> scsi0 : Found a 3ware Storage Controller at 0x7000, IRQ: 28, P-chip: 1.3
> scsi0 : 3ware Storage Controller.
> 
> Can anyone please tell me how I get to see sda-d again?
> 
> Regards,
> 
> Richard
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
