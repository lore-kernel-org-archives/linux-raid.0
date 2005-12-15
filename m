From: "Callahan, Tom" <CallahanT@tessco.com>
Subject: RE: First RAID Setup
Date: Thu, 15 Dec 2005 16:46:37 -0500
Message-ID: <0481A62A3E95A044AC20A1A45899645C06B02F4E@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tobias Hofmann' <tobias.hofmann@medien.uni-weimar.de>, Brad Campbell <brad@wasp.net.au>
Cc: "Callahan, Tom" <CallahanT@tessco.com>, 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You forgot to </delurk>

:) Happy Holidays

Tom Callahan

-----Original Message-----
From: Tobias Hofmann [mailto:tobias.hofmann@medien.uni-weimar.de]
Sent: Thursday, December 15, 2005 4:32 PM
To: Brad Campbell
Cc: Callahan, Tom; 'Andargor The Wise'; linux-raid@vger.kernel.org
Subject: Re: First RAID Setup


<delurk>

On 15.12.2005 21:46, Brad Campbell wrote:
> Callahan, Tom wrote:
> 
>> It is always wise to build in a spare however, that being said about all
>> raid levels. In your configuration, if a disk fails in your RAID5, your
>> array will go down. RAID5 is usually 3+ disks, with a mirror. So you 
>> should
>> have 3 disks at minimum, and then a 4th as a spare.
> 
> /me wonders in the days of reliable RAID-6 why we use RAID-5 + spare?

Me too. ;) So, with holidays ahead, two questions (as I might tackle 
that soon and have not found it mentioned):

- How would one "switch" from the latter to the former? Is there 
something like "grow_to_RAID_6"?
- Does RAID6 have disadvantages wrt write speed?

TIA for any comments,

greets, tobi... :)

