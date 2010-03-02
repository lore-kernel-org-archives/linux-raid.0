From: Neil Brown <neilb@suse.de>
Subject: Re: Chunk size for SSD
Date: Wed, 3 Mar 2010 07:22:07 +1100
Message-ID: <20100303072207.5d698723@notabene.brown>
References: <20100302190843.GA2446@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100302190843.GA2446@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Mar 2010 20:08:43 +0100
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
> 
> I know the topic might have already been discussed,
> but some points are still unclear to me.
> 
> Assuming to build a RAID-10 with two SSD, someone
> mentioned that the proper chunk size should be
> the erase block size, usually 128K.
> 
> Are these 128K a guessed value or there is a way
> to know the erase block size from the device itself?
> 
> Second question, assuming metadata 1.1 is used, do
> the chunks start with a chunk-size aligment?
> I mean, in a RAID-10, with 1.1 metadata, does the
> effective storage area start at a multiple of 128K,
> if a chunk of 128K is used?

No - with 1.1 and 1.2 metadata there are no guarantees about alignment of the 
start of the data section.  That is something that I plan to fix
in 3.1.2.

> 
> BTW, what if there is a partition under the RAID,
> this will offset (how much?) the start of the RAID.

It depends on the tool you use the create the partition.  Some enforce an
alignment on cylinders, others give you complete control.
I think 'sfdisk' is one of the most flexible.

NeilBrown

> 
> In general, would it be possible to specify an
> alligment for the effective storage area of the RAID?
> 
> Thanks a lot in advance,
> 
> bye,
> 

