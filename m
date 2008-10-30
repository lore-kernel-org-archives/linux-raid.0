From: David Greaves <david@dgreaves.com>
Subject: Re: diskspotting (how to tell the dead one?)
Date: Thu, 30 Oct 2008 14:36:22 +0000
Message-ID: <4909C666.9020408@dgreaves.com>
References: <200810300719.40816.Dexter.Filmore@gmx.de> <490955DD.1030607@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490955DD.1030607@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Dexter Filmore <Dexter.Filmore@gmx.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard Scobie wrote:
> Dexter Filmore wrote:
>> Assuming one has 6 disks on two controllers and one dies, how does one
>> tell the dead one? Which controller/port?
> 
> There are probably more elegant ways, but I use smartctl -a on the
> failed drive to find it's serial number and use this to find the
> location based on where I installed the drives initially, which I note
> in a text file or a label attached to the exterior of the case on
> machines with removable drive trays.

Same here.

I write the last few digits of the serial number on a label and attach it to the
drive where it is visible when you open the case.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
