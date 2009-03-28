From: "NeilBrown" <neilb@suse.de>
Subject: Re: 2.6.29 - raid10 issue - spares do not get synched automatically
Date: Sun, 29 Mar 2009 09:44:58 +1100 (EST)
Message-ID: <cf9bf069bb0926d0a5a79879af44e7fd.squirrel@neil.brown.name>
References: <49CE19F0.5040809@gmx.de>
    <b5623e48a92119937c6527b7f9564ed4.squirrel@neil.brown.name>
    <49CEA2FC.8020505@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CEA2FC.8020505@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Ringl <patrick.ringl@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, March 29, 2009 9:21 am, Patrick Ringl wrote:
> Hello Neil,
>
> NeilBrown wrote:
>> Linux RAID10 with
>>
>>      Raid Level : raid10
>>    Raid Devices : 4
>>          Layout : near=2, far=1
>>
>> Will layout data like this:
>>
>>    disk0   disk1   disk2   disk3
>>      A       A       B       B
>>      C       C       D       D
>>      E       E       F       F
>>
>> You have removed disk0 and disk1, so A,C,E don't exist
>> any more.  You should get IO errors when you try to access
>> that data.
>>
> Sorry, but I removed loop0 and loop2 so that would be disk0 and disk2 -
> so ACE as well as BDF should still exist and recover. Could you explain
> this, I am I just getting you wrong?

From the Pastezone thing...
-----------------------------------------------------
    Number   Major   Minor   RaidDevice State
       0       7        2        0      active sync   /dev/loop2
       1       7        0        1      active sync   /dev/loop0
       2       7        1        2      active sync   /dev/loop1
       3       7        3        3      active sync   /dev/loop3
pari:/mnt/debian# mdadm --manage /dev/md0 -f /dev/loop2
mdadm: set /dev/loop2 faulty in /dev/md0
pari:/mnt/debian# mdadm --manage /dev/md0 -f /dev/loop0
mdadm: set /dev/loop0 faulty in /dev/md0
---------------------------------------------------

So while you did remove loop0 and loop2, these were disk1 and disk0.

NeilBrown


