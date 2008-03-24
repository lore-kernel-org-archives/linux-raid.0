From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: component growing in raid5
Date: Mon, 24 Mar 2008 16:42:17 +0100
Message-ID: <47E7CBD9.4020900@rabbit.us>
References: <47E5FFB8.5030903@bteam.hu> <47E753C4.7030903@rabbit.us> <47E7C609.9000501@bteam.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E7C609.9000501@bteam.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Nagy Zoltan <kirk@bteam.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nagy Zoltan wrote:
> hi
> 
>> I would simply use a v1.1 superblock which will be situated at the 
>> start of
>> the array. Then you will face another problem - once you grow a leaf 
>> device,
>> mdadm will not see the new size as it will find the superblock at sect 
>> 0 and
>> will be done there. You will need to issue mdadm -A ... --update 
>> devicesize.
>> The rest of the operations are identical.
> i feeled that there is another solution that i missed  - thank you, next 
> time
> i will do it this way -- because the system is already up and running, i 
> don't wan't
> to recreate the array (about the chunksize: i've got back to 64Kb chunks 
> because
> of that bug - i was happy to see it running ;)
>>
>> As a side note I am also curious why do you go the raid55 path (I am 
>> not very
>> impressed however :)
> okay - i've run thru the whole scenario a few times - and always come 
> get back
> to raid55, what would you do in myplace? :)

The validity of the snipped arguments depends on how many devices you have at 
every level:

*) how many nodes there are?
*) how many disks per node? do all nodes have an equal amount of disks?

Without additional info I would say this: The problem with using raid5 on the 
top node is that you are stressing your network additionally for every 
r-m-w-cycle. Also rebuild of this array, especially if you add more leaves 
will be more and more resource intensive.

In contrast if the top array is RAID10 with 2 chunk copies, you will sacrifice 
half the space, however your rebuild will utilize only 2 drives (one reader 
one writer).

HTH

Peter
