From: Adam Thompson <athompso@athompso.net>
Subject: Re: Big-endian RAID5 recovery problem
Date: Mon, 01 May 2017 17:33:11 -0500
Message-ID: <8aa82733243a09e48ba87d6282d8f791@mail.athompso.net>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
 <0ab1ea1b-8035-512e-0b0a-819e15929f41@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0ab1ea1b-8035-512e-0b0a-819e15929f41@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: MUUG Roundtable <roundtable@muug.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017-05-01 16:59, Anthony Youngman wrote:
> Get hold of lsdrv, and see what that tells you. (Look at the raid wiki
> for details.) I don't know if it will have endian issues, but if it
> doesn't an expert will probably be able to chime straight in and tell
> you the create command.

Ah!  And that took me straight to the "asking for help" page.

The raw data is here: 
https://gist.github.com/anonymous/321b6db3160c259c4a4dd549817a3d07

To summarize:
* smartctl either fails to run or shows nothing wrong (depending on the 
vintage of drive, maybe?);
* mdadm --examine fails to read the superblock because of the endianness 
issue (see 
https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-0.90_Superblock_Format)
* lsdrv fails to report any useful MD topology information I could see 
(other than confirming that each md device had four members, one 
partition on each drive)

I also see 3 "FD" type partitions on each disk, but lsdrv only 
identifies *2* of them as belonging to an MD array.  Not sure what's up 
with that.


> The other thing is, read up on overlays because, if you overlay those
> disks, you will be able to "create" without actually writing to the
> disks. That way you can test - and even do a complete backup and
> recovery - without ever actually writing to, and altering, the
> original disks.

Currently reading, thanks.  Didn't know overlays could be used for block 
devices.


Spinning up a QEMU instance of Linux-PPC or Linux-MIPS with the disks in 
pass-through mode has also been mentioned, but... ugh.  Anecdotal 
reports from the web suggest that doing so would just be opening up a 
second rabbit hole in addition to the one I'm already headed down.

-Adam
