From: berk walker <berk@panix.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 09 Nov 2009 10:36:24 -0500
Message-ID: <4AF836F8.5040903@panix.com>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF829B2.5090001@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On 11/06/2009 01:45 AM, Neil Brown wrote:
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
> 
  +1

b-
