From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: RE: Good news / bad news - The joys of RAID
Date: Thu, 2 Dec 2004 20:46:53 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1041202203604.4325A-100000@Maggie.Linux-Consulting.com>
References: <200412030416.iB34Go913239@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412030416.iB34Go913239@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 2 Dec 2004, Guy wrote:

> The ECC is not the low level data.  The servo tracks are.  I bet there are
> start of track/sector header marks also.  I believe a low level format will
> not re-write the servo tracks.  Some drives reserve 1 side of 1 platter for
> servo data.  Others mix the servo data with user data.  I don't know the
> full details, just tidbit I have read over the years.

ecc is in the disk controller with the phaselock loop and other analog
circuit to convert the analog signal from the head back into 1's and 0's
for the ecc code in firmware to correct any obvious head read errors

track/sector info is written to the disk with low level format
	( usually at the manufacturer
	- you can also do lowlevel format with superformat
 
	- it contains sector and track info and other header info
	along with gaps and timing/spacing between each field

	- disks are now soft sectored .. ( no servo info )
	( 512bytes or 1K or 2K or 4K(?) bytes per sector )

	- there is just one "index" mark to indicate one full
	platter rotation

- you can change any/all of the data ... as long as the apps can
  read the data its lower-level drivers did to the disk
	- firmware level is the lowest changes ( on the disk controller )

	- some brave soles put "raid" in firmware .. 
	( risky in my book )

we use mke2fs, mkreiserfs etc to write file system data to make the
platter useful

we use software and other utilities to do more ecc checking on the 
data we expect to get back

- if the system memory is bad .. 
	we overwrite good disk data with bad data from bad memory

- if the disk read/write is bad ...
	we can sometimes compensate for it by keeping the disk
	cooler ( <= 30C for disk temp is good )

	if ecc on the disk controller cannot fix it ..  the disk
	is basically worthless

c ya
alvin

