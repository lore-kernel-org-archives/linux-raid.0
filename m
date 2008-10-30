From: "Billy Crook" <billycrook@gmail.com>
Subject: Re: diskspotting (how to tell the dead one?)
Date: Thu, 30 Oct 2008 16:33:01 -0500
Message-ID: <a43edf1b0810301433t7a8c9d4dvaee99413bf2248a4@mail.gmail.com>
References: <200810300719.40816.Dexter.Filmore@gmx.de>
	 <490955DD.1030607@sauce.co.nz>
	 <7315746F7EFCAF4A93699CE8FA579786148D6A3211@exchange07.valvesoftware.com>
	 <200810301818.02940.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200810301818.02940.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Chris Green <cgreen@valvesoftware.com>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 30, 2008 at 12:18, Dexter Filmore <Dexter.Filmore@gmx.de> wrote:
> Am Donnerstag, 30. Oktober 2008 17:47:31 schrieb Chris Green:
>> cp /dev/md0 /dev/null
>>
>> And then look at which drive's light isn't on.
>>
> Thing is they don't have individual lights, they're just sitting in the tower,
> no backplane or such.

tar md0's contents, pipe into /dev/null, and use a stethoscope to find
the one drive that's not clicking wildly?

Seriously.  Getting the serial number with smartctl or hdparm, and
searching through the disks for that SN while the machine is offline
is probably the safest route if you aren't absolutely certain which
drives are where.  With anything less certain than the serial number,
there's noteable chance you could pick wrong.  Depending on what raid
level is used, and how failed it is, you might not have the liberty of
a second try if you pull the wrong drive with the array in use.
