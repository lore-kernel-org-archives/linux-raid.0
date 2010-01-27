From: Nagilum <nagilum@nagilum.org>
Subject: Re: How can I tell what drive is sdb?
Date: Wed, 27 Jan 2010 19:10:37 +0100
Message-ID: <20100127191037.459744dmff2r3i4g@cakebox.homeunix.net>
References: <1264601024.29409.19.camel@thor>
 <bdd6985b1001270609m477799dpdcd625180efaed02@mail.gmail.com>
 <4B604B2B.7070602@computer.org>
 <18879E40-1CB7-47B0-90C5-1F4483729E3D@crc.id.au>
 <bdd6985b1001270629g38a371abtd513ec54d2feb77f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bdd6985b1001270629g38a371abtd513ec54d2feb77f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Message from matthew.garman@gmail.com ---------
     Date: Wed, 27 Jan 2010 08:29:50 -0600
     From: Matt Garman <matthew.garman@gmail.com>
  Subject: Re: How can I tell what drive is sdb?
       To: Steven Haigh <netwiz@crc.id.au>
       Cc: linux-raid@vger.kernel.org


> On Wed, Jan 27, 2010 at 8:21 AM, Steven Haigh <netwiz@crc.id.au> wrote:
>>
>> On 28/01/2010, at 1:18 AM, Jan Ceuleers wrote:
>>
>>> Matt Garman wrote:
>>>>> Is there a way to identify what drive is what?
>>>>
> Another tedious approach: use smartctl or hdparm as suggested above to
> get an initial mapping of /dev/sdX to serial number.  Then, disconnect
> the SATA cable of all but one drive, and reboot.  Now look at what
> /dev/sda's serial number is, and compare that to the initial mapping.
> Eventually /dev/sda will correspond to /dev/sdb when all drives are
> connected.
>
> If the controller supports hotswap, you could do something similar
> without so many reboots.
>
> This scheme makes the assumption that it's easier to pull SATA cables
> than just look at the drive's serial numbers.

blkid could also be used to identify the drives.
It should work with all types of drives SCSI/SATA/PATA/USB/...


----- End message from matthew.garman@gmail.com -----



========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
