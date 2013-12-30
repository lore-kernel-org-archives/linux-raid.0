From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Doesn't "writes" do what resync does ?
Date: Tue, 31 Dec 2013 01:20:27 +1300
Message-ID: <52C1650B.8000208@insync.za.net>
References: <52C0AD5A.1040802@insync.za.net> <52C11FDF.1040307@hardwarefreak.com> <52C13072.2060303@insync.za.net> <52C15B5B.3090505@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C15B5B.3090505@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/12/2013 00:39, Stan Hoeppner wrote:
> On 12/30/2013 2:36 AM, Pieter De Wit wrote:
>> On 30/12/2013 20:25, Stan Hoeppner wrote:
>>> On 12/29/2013 5:16 PM, Pieter De Wit wrote:
>>>> <snip>
>>>> Should that resync not have had more completed ?
>>> Your question is invalid.  What you meant to ask is
>>>
>>> "Why are pvdisplay and mdstat reporting what seems to be conflicting
>>> state data?"
>>>
>>> Did you also ask on the lvm list why pvdisplay says most PEs are
>>> consumed, yet mdstat says resync is only 17% complete?
>>>
>> Hi again Stan,
>>
>> pvdisplay says most PEs are consumed because I moved that data to the
>> device. My question, rephased then:
>>
>> Shouldn't writes to a RAID device count as resyncs ?
> The resync process is independent of normal IO.  It starts at the
> beginning and soldiers on to the end doing a read of each sector pair
> then comparing them (for RAID1).  So no, writes don't count as resync
> operations.  md doesn't perform write/read/verify in normal operation,
> only write.  Linux relies on hardware to report write errors, and
> assumes the data hit the disk intact if no error.  There is no mechanism
> to pass a new write as verified to the resync process.  If you think it
> should you may want to shoot the idea past Neil.  Though I'm sure he's
> already considered that and rejected it for various reasons.
>
> And unless you restart the resync, it won't verify any sectors you wrote
> up to its current position.  Any sectors you wrote after that point it
> will be verifying.  You don't need to restart the resync or do another
> one.  I'm simply explaining how the resync is independent of normal
> write IO.
>
Hi Stan,

I will leave the email intact for Neil. Neil, please point out anything 
I have missed :)

I understand, but why is the following not the same then (let's stick to 
RAID 1 for now, just to make it easier)

* Read both sectors, yip, they are the same
* Write both sectors with the same data, none reported an error

The one outstanding thing I can think of is that this will require a 
major re-write of the code. I *assume* that MD doesn't track the resync 
progress by bitmap, but rather by sector count.

The second is that it could become hell to update a bitmap if there in 
threads involved, I am also guessing it will create havoc for the 
scheduler, since a write now has to update the bitmap, but in order to 
do so, it needs a memory lock, which means that it might have to wait 
for the sync read to complete.

Cheers,

Pieter
