From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Thu, 27 Oct 2005 12:12:21 -0700
Message-ID: <200510271912.j9RJCLYH008288@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> The partial media failure problem described here is exactly why it's
>> important to run smartmontools in combination with your RAID array
>> of any level.  By running regular checks of the disk surface you can
>> know well ahead of time that you're going to have trouble.  in
>> practice this more than mitigates the risk of partial media failure.
>> 
>> http://smartmontools.sourceforge.net/

><sigh> I wish the code to enable SMART for SATA drives would make it 
>into mainstream *real* soon now.

In addition to the libatapatches, the 3ware sata controllers support SMART.
They are about $250 used on ebay for a 12 drive card. Still 4x as
expensive as a 4 drive controller but only one slot VS three...

HTH

