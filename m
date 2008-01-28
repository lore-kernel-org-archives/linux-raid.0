From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Use new sb type
Date: Mon, 28 Jan 2008 20:10:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801281955070.1185@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr>
 <479E1C95.1040008@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479E1C95.1040008@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 28 2008 18:19, David Greaves wrote:
>Jan Engelhardt wrote:
>> This makes 1.0 the default sb type for new arrays.
>> 
>
>IIRC there was a discussion a while back on renaming mdadm options
>(google "Time to deprecate old RAID formats?") and the superblocks
>to emphasise the location and data structure. Would it be good to
>introduce the new names at the same time as changing the default
>format/on-disk-location?

The -e 1.0/1.1/1.2 is sufficient for me, I would not need
--metadata 1 --metadata-layout XXX.

So renaming options should definitely be a separate patch.
