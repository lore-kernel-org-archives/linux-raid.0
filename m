From: Phil Turmel <philip@turmel.org>
Subject: Re: Is trim/discard supported on LVM RAID logical volume?
Date: Wed, 30 Nov 2016 11:18:06 -0500
Message-ID: <5f9b0cc6-3060-717b-f438-92dc8837804e@turmel.org>
References: <CAEtPA0ByX8yYx8xNc_=4SP0bqXVz-D4o-bM5XZF8Y6NcnqsEKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEtPA0ByX8yYx8xNc_=4SP0bqXVz-D4o-bM5XZF8Y6NcnqsEKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Dung <mpatdung@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/29/2016 07:59 AM, Patrick Dung wrote:
> Hello,
> 
> Sorry if it is a cross posting.
> I had post my question in linux-lvm mailing list but did not have reply.
> 
> In my old setting, fstrim is supported:
> ext4 over LVM over MD software raid 1 (mdadm) > SSD.
> 
> After reading the recommendation in RHEL 6
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/ch-ssd.html
> 
> I changed to use raid 1 mirror using 'LVM RAID logical volume'. It
> make use of MD raid internally.
> But I found fstrim does not work anymore. Is the behavior expected?

I can't remember when it was changed, but md raid is only trustworthy
for the mirroring types, and only if the underlying devices return
zeroes when reading trimmed blocks.  Since this isn't guaranteed, and I
recall reading that some devices that claim to return zeroes don't, md
raid cannot determine automatically if it is safe.

Theoretically, raid5 could be compatible if the underlying device
returns zeros, and trims always cover entire stripes.  But that would
require code within mdadm to track stripe-fragment trims that have been
received.  Blegh.

Phil

