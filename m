From: Dieter Stueken <stueken@conterra.de>
Subject: Re: Partition or whole disk ?
Date: Wed, 30 Jun 2004 18:40:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E2ED12.9020703@conterra.de>
References: <1088604941.2840.1.camel@JubJub>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1088604941.2840.1.camel@JubJub>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Josh Litherland wrote:
> Couldn't find an authoritative answer to this in the faq or elsewhere...
> Is it preferred to build md sets out of whole disks or of partitions ? 
> Is there any functional reason why either one is better ?

If you make partitions, about one track is is "wasted" to store
the useless partition table. Thus I used whole disks for a long time.

The problem might be, that "fdisk -l" won't show up if this
disk is an MD device. It shows an empty partition table which
may look like an unused/empty disk. If you create the partition
table, you may waste some data, but fdisk may show this is a
disk with a partition containing some MD data on it.

Meanwhile I turned back to make partition tables again,
just to "tag" the disk as "in use". If I put a new disk
into my system, it has no partition table. Thus I can verify
this condition, before I initialize the disk. This may prevent
me from accidentally initialize/destroying some disk in use,
which already has an partition table.

Dieter.

