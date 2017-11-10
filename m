From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what
 now?
Date: Fri, 10 Nov 2017 14:04:34 -0500
Message-ID: <8822270a-a88b-fe9a-daae-22df155f5062@turmel.org>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk>
 <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
 <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
 <CAA4aoFbOnCtj_+qbfuzz7qS6xrt5HB9XJK-E+h0_eEu=vLdftg@mail.gmail.com>
 <3fa05723-8275-8840-7fbc-397801fa17de@turmel.org>
 <0B536D2C-1919-4704-94D3-6EB733B73E9D@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0B536D2C-1919-4704-94D3-6EB733B73E9D@gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>
Cc: Mark Knecht <markknecht@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2017 01:15 PM, Jun-Kai Teoh wrote:

>>> Am in the process of backup right now.
>>> 
>>> And yes, the drive/array is mounted.
>> 
>> Ok.  I reviewed the other thread.  Consider creating a new array 
>> from scratch after you complete your backups, using consistent 
>> partitioning across all devices.  I would put LVM on top and leave 
>> part of it unallocated (for emergencies), but that's just my 
>> preference.

> I'm backing up as much as I can, but I don't think I'll be able to 
> back up everything. I can back up very little of the data, so I'm 
> trying to prioritize carefully right now.

Ah, ok.  Well, after you get the important stuff backed up, you can
add more devices as spares and try to let MD continue its grow and
rebuild operations.  It might end up completing.

But don't add any more complete devices to the array -- use a partition
that starts at 1MB and covers the rest of the device (default for most
partition tools nowadays).

I recommend that when/if your array is stable again, you add one more
spare (with partition) and then use mdadm's --replace operation to move
complete-device members to the new member.  When each is done, take the
newly freed device and partition it and do the next.  When you have no
more complete-device members and have the last freed device partitioned,
consider converting to raid6 with that spare.

All of that will take many days, but can be done safely while running
the system.

> All devices are just 4TB drives, I didn't partition them separately 
> for the array - or am I misunderstanding what you mean? <-- This is 
> really common, all of you are far more knowledgeable than I am and I 
> only understand some of the terms sometimes.

MD raid doesn't care if you use whole devices of if you use partitions.
But other system utilities can get confused, and can even write a
new, unwanted partition table.  (I recall seeing that with a NAS
product a while back.)  So, the 1MB lost is good insurance against
stupid tools.

Phil
