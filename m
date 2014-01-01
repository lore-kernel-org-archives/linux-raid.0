From: Tomas M <tomas@slax.org>
Subject: Re: Looking for help how to migrate 2disk RAID1 to 3 disk RAID6
Date: Wed, 1 Jan 2014 08:15:48 +0100
Message-ID: <CAL1oBhrzkxKTBaBBsa=1jEG4TGj_+oTNBCa8mH=CmYyXgtpiGw@mail.gmail.com>
References: <1388537511.5058.22.camel@oxygen.netxsys.com> <52C36908.2010701@insync.za.net>
 <1388552041.5058.25.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388552041.5058.25.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k-list@adamski.org>
Cc: Pieter De Wit <pieter@insync.za.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> RAID Level 6 requires a minimum of 4 drives to implement
>>
> I have seen messages by Neil from 2011 that he was planning to remove
> this silly minimum requirement of 4 drive for RAID6.

What is silly on that? :-)
IMHO if you need redundancy, you can simply use RAID1 on the three
drives, and then you can add more drives to the array.

I'm not sure what is your real intention here, why do you insist on
RAID6, you said you'd like to add another drive maybe later to the
array, but I'm not sure if RAID6 even supports adding new drives
(while growing its size). As far as I tested, it reports error: mdadm:
can only add devices to linear arrays (I assume RAID6 is not a linear
array)

Tomas M
