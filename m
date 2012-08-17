From: David Brown <david.brown@hesbynett.no>
Subject: Re: raid5 to utilize upto 8 cores
Date: Fri, 17 Aug 2012 09:52:40 +0200
Message-ID: <502DF848.6050903@hesbynett.no>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com> <502C8C18.5070501@hardwarefreak.com> <CAEyJA_sfAUk9PNFfss9m=pAi90Pb0gTHo9seV-BDexr3pLVvxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEyJA_sfAUk9PNFfss9m=pAi90Pb0gTHo9seV-BDexr3pLVvxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent Ferrer <vincentchicago1@gmail.com>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/08/2012 00:11, vincent Ferrer wrote:
> On Wed, Aug 15, 2012 at 10:58 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 8/15/2012 9:56 PM, vincent Ferrer wrote:
>>
>>> - My  storage server  has upto 8 cores  running linux kernel 2.6.32.27.
>>> - I created  a raid5 device of  10  SSDs .
>>
>> No it is not normal practice.  I 'preach' against it regularly when I
>> see OPs doing it.  It's quite insane.
>>
>> There are a couple of sane things you can do today to address your problem:
>>
>> Stan
>>
>
> Hi Stan,
> Follow-up question for  2  types of setups i may have to prepare:
> 1) setup A   has   80   SSDs.    Question: Should I still  create one
> raid5 device or should I create  8  raid5 device each having 10 SSDs ?
>      My linux based storage server may be accessed by  upto   10-20
> physically  different clients.
>

I have difficultly imagining the sort of workload that would justify 80 
SSDs.  Certainly you have to think about far more than just the disks or 
the raid setup - you would be looking at massive network bandwidth, 
multiple servers with large PCI express buses, etc.  Probably you would 
want dedicated SAN hardware of some sort.  Otherwise you could get 
pretty much the same performance and capacity using 10 hard disks (and 
maybe a little extra ram to improve caching).

But as a general rule, you want to limit the number of disks (or 
partitions) you have in a single raid5 to perhaps 6 devices.  With too 
many devices, you increase the probability that you will get a failure, 
and then a second failure during a rebuild.  You can use raid6 for extra 
protection - but that also (currently) suffers from the single-thread 
bottleneck.

Remember also that raid5 (or raid6) requires a RMW for updates larger 
than a single block but smaller than a full stripe - that means it needs 
to read from every disk in the array before it can write.  The wider the 
array, the bigger effect this is.

>   2) Setup B  has only 12 SSDs.  Question:  Is it more practical to
> have only one raid5  device,  even though I may have 4-5  physically
> different  clients or create 2 raid5 devices each having  6 SSDs.

Again, I would put only 6 disks in a raid5.

>
> Reason I am asking because I have seen enterprise storage arrays from
> EMC/IBM where new raid5 device is created on demand  and (storage
> firmware may spread across automatically across all the available
> drives/spindles or can be intelligently selected by storage admin by
> analyzing  workload to avoid  hot-spots)
>
> Partitioning was only done because I am still waiting  budget approval
> to buy SSDs.
>
> regards
> vincy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

