From: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Subject: Re: First RAID Setup
Date: Thu, 15 Dec 2005 22:31:58 +0100
Message-ID: <43A1E0CE.7090805@medien.uni-weimar.de>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com> <43A1D642.2010301@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43A1D642.2010301@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: "Callahan, Tom" <CallahanT@tessco.com>, 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

