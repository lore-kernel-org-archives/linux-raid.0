From: "Guy" <bugzilla@watkins-home.com>
Subject: hard disk re-locates bad block on read.
Date: Mon, 10 Jan 2005 12:35:10 -0500
Message-ID: <200501101735.j0AHZI922122@www.watkins-home.com>
References: <200501101713.j0AHDx922062@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101713.j0AHDx922062@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My disks have the option to relocate bad blocks on read error.
I was concerned that bogus data would be returned to the OS.

They say CRC errors return corrupt data to the OS!  I hope not!
So it seems CRC errors and unreadable blocks both are corrupt or lost.
But the OS does not know.
So, I will leave this option turned off.

Guy

I sent this to Seagate:
With ARRE (Automatic Read Reallocation Enable) turned on.  Does it  relocate
blocks that can't be read, or blocks that had correctable read  problems?
Or both?

 If it re-locates un-readable blocks, then what data does it return to the
OS?

 Thanks,
 Guy

==================================================================

Guy,
 If the block is bad at a hardware level then it is reallocated and a spare
is used in it's place. In a bad block the data is lost, the sparing of the
block is transparent to the operating system. Blocks with correctable read
problems are one's with corrupt data at the OS level.

 Jimmie P.
 Seagate Technical Support

