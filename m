From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: diskspotting (how to tell the dead one?)
Date: Thu, 30 Oct 2008 19:36:13 +1300
Message-ID: <490955DD.1030607@sauce.co.nz>
References: <200810300719.40816.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200810300719.40816.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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
