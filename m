From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: LVM performance
Date: Fri, 22 Feb 2008 14:41:45 +0100
Message-ID: <47BED119.4070000@student.tuwien.ac.at>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>	<20080218154203.6e2d1483@szpak>	<47BB30DF.1080006@student.tuwien.ac.at> <18364.6868.854623.613958@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18364.6868.854623.613958@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi schrieb:
> Those are as such not very meaningful. What matters most is
> whether the starting physical address of each logical volume
> extent is stripe aligned (and whether the filesystem makes use
> of that) and then the stripe size of the parity RAID set, not
> the chunk sizes in themselves.
> 
> I am often surprised by how many people who use parity RAID
> don't seem to realize the crucial importance of physical stripe
> alignment, but I am getting used to it.

Am I right to assume that stripe alignment matters because of the 
read-modify-write cycle needed for unaligned writes? If so, how come a 
pure read benchmark (hdparm -t or plain dd) is slower on the LVM device 
than on the md device?


Oliver
