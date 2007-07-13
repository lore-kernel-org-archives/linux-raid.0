From: Jon Collette <jon@etelos.com>
Subject: Re: 3ware 9650 tips
Date: Fri, 13 Jul 2007 11:54:05 -0700
Message-ID: <4697CA4D.6020304@etelos.com>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wouldn't Raid 6 be slower than Raid 5 because of the extra fault tolerance?
    http://www.enterprisenetworksandservers.com/monthly/art.php?1754 - 
20% drop according to this article

His 500GB WD drives are 7200RPM compared to the Raptors 10K.  So his 
numbers will be slower. 

Justin what file system do you have running on the Raptors?  I think 
thats an interesting point made by Joshua.


Justin Piszcz wrote:
>
>
> On Fri, 13 Jul 2007, Joshua Baker-LePain wrote:
>
>> My new system has a 3ware 9650SE-24M8 controller hooked to 24 500GB 
>> WD drives.  The controller is set up as a RAID6 w/ a hot spare.  OS 
>> is CentOS 5 x86_64.  It's all running on a couple of Xeon 5130s on a 
>> Supermicro X7DBE motherboard w/ 4GB of RAM.
>>
>> Trying to stick with a supported config as much as possible, I need 
>> to run ext3.  As per usual, though, initial ext3 numbers are less 
>> than impressive. Using bonnie++ to get a baseline, I get (after doing 
>> 'blockdev --setra 65536' on the device):
>> Write: 136MB/s
>> Read:  384MB/s
>>
>> Proving it's not the hardware, with XFS the numbers look like:
>> Write: 333MB/s
>> Read:  465MB/s
>>
>> How many folks are using these?  Any tuning tips?
>>
>> Thanks.
>>
>> -- 
>> Joshua Baker-LePain
>> Department of Biomedical Engineering
>> Duke University
>>
>
> Let's try that again with the right address :)
>
>
> You are using HW RAID then?  Those numbers seem pretty awful for that
> setup, including linux-raid@ even it though it appears you're running 
> HW raid,
> this is rather peculiar.
>
> To give you an example I get 464MB/s write and 627MB/s with a 10 disk
> raptor software raid5.
>
> Justin.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

