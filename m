From: Chris Green <cgreen@valvesoftware.com>
Subject: RE: diskspotting (how to tell the dead one?)
Date: Thu, 30 Oct 2008 09:47:31 -0700
Message-ID: <7315746F7EFCAF4A93699CE8FA579786148D6A3211@exchange07.valvesoftware.com>
References: <200810300719.40816.Dexter.Filmore@gmx.de>
 <490955DD.1030607@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490955DD.1030607@sauce.co.nz>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: 'Richard Scobie' <richard@sauce.co.nz>, Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

cp /dev/md0 /dev/null

And then look at which drive's light isn't on.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Richard Scobie
Sent: Wednesday, October 29, 2008 11:36 PM
To: Dexter Filmore
Cc: Linux RAID Mailing List
Subject: Re: diskspotting (how to tell the dead one?)

Dexter Filmore wrote:
> Assuming one has 6 disks on two controllers and one dies, how does one tell
> the dead one? Which controller/port?

There are probably more elegant ways, but I use smartctl -a on the
failed drive to find it's serial number and use this to find the
location based on where I installed the drives initially, which I note
in a text file or a label attached to the exterior of the case on
machines with removable drive trays.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
