From: Tom Coughlan <coughlan@redhat.com>
Subject: Re: hard disk re-locates bad block on read.
Date: Tue, 11 Jan 2005 09:34:33 -0500
Message-ID: <1105454073.11357.96.camel@bianchi.boston.redhat.com>
References: <200501101735.j0AHZI922122@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101735.j0AHZI922122@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2005-01-10 at 12:35, Guy wrote:
> My disks have the option to relocate bad blocks on read error.
> I was concerned that bogus data would be returned to the OS.
> 
> They say CRC errors return corrupt data to the OS!  I hope not!
> So it seems CRC errors and unreadable blocks both are corrupt or lost.
> But the OS does not know.
> So, I will leave this option turned off.
> 
> Guy
> 
> I sent this to Seagate:
> With ARRE (Automatic Read Reallocation Enable) turned on.  Does it  relocate
> blocks that can't be read, or blocks that had correctable read  problems?
> Or both?

FWIW, the SCSI standard has been clear on this point for many years:

"An ARRE bit of one indicates that the device server shall enable
automatic reallocation of defective data blocks during read operations.
... The automatic reallocation shall then be performed only if the
device server successfully recovers the data. The recovered data shall
be placed in the reallocated block." (SBC-2)

Blocks that can not be read are not relocated. The read command simply
returns an error to the OS.

> 
>  If it re-locates un-readable blocks, then what data does it return to the
> OS?
> 
>  Thanks,
>  Guy
> 
> ==================================================================
> 
> Guy,
>  If the block is bad at a hardware level then it is reallocated and a spare
> is used in it's place. In a bad block the data is lost, the sparing of the
> block is transparent to the operating system. Blocks with correctable read
> problems are one's with corrupt data at the OS level.
> 
>  Jimmie P.
>  Seagate Technical Support
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

