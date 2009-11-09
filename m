From: "Neil F Brown" <nfbrown@novell.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Tue, 10 Nov 2009 07:22:17 +1100
Message-ID: <423765b7af1be77f0a40dcbbb1f65c4b.squirrel@neil.brown.name>
References: <19187.50708.551325.297625@notabene.brown>
    <4AF829B2.5090001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF829B2.5090001@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, November 10, 2009 1:39 am, Doug Ledford wrote:
> On 11/06/2009 01:45 AM, Neil Brown wrote:
>>
>> Greetings.
>>
>>  About a week ago I released mdadm-3.1
>>  I have now 'withdrawn' it meaning that it doesn't appear on the
>>  kernel.org mirrors any more, and I ask people not to use it.
>
> Although the cause for this sucks, I was actually going to suggest that
> since 3.1 is a version bump, that we take the opportunity to change a
> few defaults.  Like switching to version 1 superblocks instead of
> version 0 by default.  And changing the default chunk size to 512k
> instead of 64k.  The time has simply come for the 0->1 superblock
> change, and I have a good deal of data showing that for SATA disks at
> least, the 512k chunk size is the typical sweet  spot.

I had been toying with that idea myself - certainly of changing the
defaults soon.
I'm tempted to make the default metadata "1.1" though possibly not for
RAID1.  For RAID0,4,5,6,10 there is no value in having the metadata
at the end of the device.  For RAID1 there is as it makes booting off
any member easier.
Thoughts?


I'm certainly happy with increasing the chunksize to 512K.

NeilBrown

