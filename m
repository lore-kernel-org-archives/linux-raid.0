From: Mark Lord <liml@rtr.ca>
Subject: Re: SSD data reliable vs. unreliable [Was: Re: Data Recovery from
 	SSDs - Impact of trim?]
Date: Mon, 26 Jan 2009 13:21:14 -0500
Message-ID: <497DFF1A.2050401@rtr.ca>
References: <87f94c370901221553p4d3a749fl4717deabba5419ec@mail.gmail.com>	 <497A2B3C.3060603@redhat.com>	 <1232749447.3250.146.camel@localhost.localdomain>	 <87f94c370901231526jb41ea66ta1d6a23d7631d63c@mail.gmail.com>	 <497A542C.1040900@redhat.com>	 <7fce22690901260659u30ffd634m3fb7f75102141ee9@mail.gmail.com>	 <497DE35C.6090308@redhat.com>	 <87f94c370901260934vef69a2cgada9ae3dfdb440ef@mail.gmail.com>	 <497DF807.7010600@rtr.ca> <87f94c370901261009w431156fbx4d2b20638dc5097c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87f94c370901261009w431156fbx4d2b20638dc5097c@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@norcrossgroup.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Dongjun Shin <djshin90@gmail.com>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Greg Freemyer wrote:
>
> Just so I know and before I try to find the right way to comment to
> the T13 and T10 committees:
> 
> What is the negative of adding a ATA/SCSI command to allow the storage
> device to be interrogated to see what sectors/blocks/erase-units are
> in a mapped vs. unmapped state?
> 
> For T13 (ATA), it would actually be a tri-state flag I gather:
> 
>   Mapped - last data written available
>   unmapped - no data values assigned
>   unmapped - deterministic data values
> 
> Surely the storage device has to be keeping this data internally.  Why
> not expose it?
..

That's a good approach.  One problem on the drive end, is that they
may not be maintain central lists of these.  Rather, it might be stored
as local flags in each affected sector.

So any attempt to query "all" is probably not feasible,
but it should be simple enough to "query one" sector at a time
for that info.  If one wants them all, the just loop over
the entire device doing the "query one" for each sector.

Another drawback to the "query all", is the size of data (the list)
returned is unknown in advance.  We generally don't have commands
that work like that.

Cheers
