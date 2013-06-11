From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: Re: Help with failed RAID-5 -> 6 migration
Date: Tue, 11 Jun 2013 12:42:41 +0000
Message-ID: <CDDC92D8.471B8%michael.vanhorn@wright.edu>
References: <51B6FF7E.1000707@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B6FF7E.1000707@turmel.org>
Content-Language: en-US
Content-ID: <7ECDA698DA37F045839B53F75F873480@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Keith Phillips <spootsy.ootsy@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Using Keith Phillips' reported output from /proc/mdstat and mdadm
--detail, I have a question:

/proc/mdstat says that the array is "inactive":

>>---------------------------
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md0 : inactive sde[4] sdc[1] sdb[0] sdd[3]
>>       7814054240 blocks super 1.2
>> 
>> unused devices: <none>
>> ---------------------------

But mdadm --detail says

>>           State : active, degraded, Not Started

and goes on to show that the array is rebuilding using the spare. So, how
can it be both "inactive" and "active", and be rebuilding but "Not
Started"? 

I think this is just my un-clarity concerning what these terms mean.

Thanks!

---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




