From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: LVM performance
Date: Mon, 10 Mar 2008 13:32:30 +1300
Message-ID: <47D4819E.5010807@sauce.co.nz>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>	<20080218154203.6e2d1483@szpak>	<47BB30DF.1080006@student.tuwien.ac.at>	<18364.6868.854623.613958@tree.ty.sabi.co.UK>	<47BED119.4070000@student.tuwien.ac.at> <18384.63840.605334.155518@tree.ty.sabi.co.UK> <47D440D6.90509@student.tuwien.ac.at> <8D0FC34E-F0B0-4BAF-A466-2C8BC439E7FF@it-loops.com> <47D47264.4070404@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47D47264.4070404@student.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Oliver Martin wrote:
> Michael Guntsche schrieb:

> whenever possible. But if the fs starts 64KB into a 128KB stripe, every 
> 128KB write will cause two RMW cycles.
> At least, that's how I understand it. Maybe there's something else 
> involved and it really doesn't make a difference?

As I understand it, XFS is smart enough to work with md RAID and 
automagically set the correct swidth and sunit sizes to suit the array.

Regards,

Richard
