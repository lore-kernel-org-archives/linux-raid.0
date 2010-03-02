From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Chunk size for SSD
Date: Tue, 2 Mar 2010 20:08:43 +0100
Message-ID: <20100302190843.GA2446@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I know the topic might have already been discussed,
but some points are still unclear to me.

Assuming to build a RAID-10 with two SSD, someone
mentioned that the proper chunk size should be
the erase block size, usually 128K.

Are these 128K a guessed value or there is a way
to know the erase block size from the device itself?

Second question, assuming metadata 1.1 is used, do
the chunks start with a chunk-size aligment?
I mean, in a RAID-10, with 1.1 metadata, does the
effective storage area start at a multiple of 128K,
if a chunk of 128K is used?

BTW, what if there is a partition under the RAID,
this will offset (how much?) the start of the RAID.

In general, would it be possible to specify an
alligment for the effective storage area of the RAID?

Thanks a lot in advance,

bye,

-- 

piergiorgio
