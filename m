From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: Re: RAID 5 disk format for Promise SuperTrak Sx6000 (Linux)
Date: Sun, 26 May 2002 11:42:38 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001801c204e5$1daf12f0$0505a8c0@PLUTO>
References: <f04330107b915ec475e78@[192.168.254.56]>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, ewitness - Ben Fowler <bfowler@ewitness.co.uk>
Cc: ewitness - David Pearce <dp@ewitness.co.uk>
List-Id: linux-raid.ids

Ben,

If I understand you correctly - you are trying to use
Linux RAID (which is a self contained software system),
to read the disk information written by the IBM/Mylex
controller (which is proprietary hardware RAID system
deveoped by IBM/Mylex), instead of using
IBM/Mylex controller - there is no easy way to do that,
unless you know the IBM/Mylex RAID firmware and data
structures. If you have firmware documents that IBM gives to
the OEMs, then you can start from reading the COD information
(In IBM term, "Configuration On Disk". This is like super block,
but has whole lots of things in it ) / understand how the Logical
drives are created / what connects to what. To access the data is
rather difficult without controller and firmware. I don't think you
can get the data by only know that logical drive is using RAID5
with right-asymmetric parity algorithm. Maybe most of the data in
the data area can be read correctly, but even if small number of
blocks been read wrongly, data lost will be pretty bad. This really
has nothing to do with Linux RAID software.

Maybe I don't really understand what you are trying to do.

-Wei

----- Original Message -----
From: "ewitness - Ben Fowler" <bfowler@ewitness.co.uk>
To: <linux-raid@vger.kernel.org>
Cc: "ewitness - David Pearce" <dp@ewitness.co.uk>
Sent: Saturday, May 25, 2002 7:35 PM
Subject: RAID 5 disk format for Promise SuperTrak Sx6000 (Linux)


> Just as a standard disk has a standard format with MBR, partition
> table, superblock, root directory et cetera; I assume that the disks
> making up a RAID 5 array have a defined format covering the 'superblock',
> striping, parity and so forth.
>
> Is this standard for all RAID compliant/certified systems? Is it
> defined by each vendor? Is the format/system used by Promise
> published anywhere?
>
> Owing to the the sequential ocurrence of a number of circumstances
> each of which was distinctly unlikely. I have the job of trying to
> read 120 GB of data from a 240 GB RAID 5 Array attached to
> a Supertrak Sx6000 controller card. The software that handles
> the raid is on the card's BIOS and so far as I know is proprietary.
>
> I know that I need help because of the five disks making up the array
> no fewer than three are recognised as 'free', that is, not part
> of the array. I suspect that the data on these disks is fine, and
> that the problem was a transient failure on one of the disks, followed
> by a catastrophe. If I knew how, I would 'force' the controller to
> use and resync those disks.
>
> I suspect my job would be measurably easier and greatly eased if I could
> use the standard Linux tools such as mkraid. See
> <URL:
http://www.mail-archive.com/linux-raid@vger.rutgers.edu/msg07932.html >
> which contains the highly optimistic suggestion:
>
> The problem was how to read using the Linux RAID 5 software,
> the data written by Mylex controller. I wrote a few test
> programs, and found that the Mylex AcceleRaid controller is
> using what Linux software RAID calls right-asymmetric parity
> algorithm (you will find the part of /etc/raidtab file I use,
> at the end of this mail), so I could read the data using Linux
> software RAID (mkraid --force --dangerous-no-resync /dev/md2).
>
> Is there something similar for the Sx6000? How can I find out?
>
> Ben.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


