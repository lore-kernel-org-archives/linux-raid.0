From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Mdadm server eating drives
Date: Tue, 02 Jul 2013 14:54:01 -0500
Message-ID: <51D32FD9.3020906@hardwarefreak.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com> <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com> <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se> <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com> <51CC72A4.4040508@jungers.net> <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gma
 il.com> <51D233A5.504@hardwarefreak.com> <CAPSPcXjOPben0xGqcUKwyZn4pX403uFbp5f57f=LEV371ZuDjw@mail.gmail.com> <51D32DBB.8030401@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D32DBB.8030401@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Forgot to ask previously.  This system is attached to a UPS isn't it?

-- 
Stan


On 7/2/2013 2:44 PM, Stan Hoeppner wrote:
> On 7/2/2013 10:48 AM, Barrett Lewis wrote:
>> After sending the last email I went out and bought 2 new WD reds, and
>> a new motherboard.  I came back and in those 2 hours all but 1 of my
>> drives failed to the point of being unable to read the superblock so
>> it really seems like my array is ended
> 
> The drive may be ok.  They all may be.
> 
>> On Mon, Jul 1, 2013 at 8:57 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>>> I noticed one drive was going up and down and determined that
>>>> the drive had actual physical damage to the power connecter and
>>>> was losing and regaining power through vibration.
>>>
>>> This intermittent contact could have damaged the PSU.  You've continued
>>> to have drive and lockup problems since replacing this drive with bad
>>> connector.
>>
>> I hadn't thought of it until you said so but I bet you are right about
>> the iffy connector.  It certainly seemed as if I never had an issue
>> with the array for 8 months, and then suddenly everything got unstable
>> at once, and since then I've lost atleast 6 hard drives.
> 
> Your drives may not be toast.  Don't toss them out, and don't throw up
> your hands yet.
> 
>>> The pink elephant in the room is thermal failure due to insufficient
>>> airflow.  The symptoms you describe sound like drives overheating.  What
>>> chassis is this?  Make/model please.  If you've installed individual
>>> drive hot swap cages, etc, it would be helpful if you snapped a photo or
>>> two and made those available.
>>
>> It is also possible that there were cooling issues.  The case is an
>> NZXT H2.  It has some fans blowing directly on all the hard drives,
>> but there were a few times I have to admit I took the fans off to work
>> on things and forgot to put them back on for a few days, coming back
>> to find them very hot to the touch.  I would have mentioned that
>> earlier, but a data recovery place told me that it was unlikely that
>> would be a culprit (after they had my money).
> 
> I checked out the chassis on the NZXT site.  With the front fans
> removed, you have only 2x120mm low rpm, low static pressure, and low CFM
> exhaust fans, one on in the PSU, one top rear.  With 8 drives packed in
> such close proximity and with other lower resistance intake paths (the
> perforated chassis bottom), you won't get enough air through the front
> drive cage to cool those drives properly over a long period.
> 
> However, running with the two front fans removed for a couple of days on
> an occasion or two shouldn't have overheated the drives to the point of
> permanent damage, assuming ambient air temp was ~75F or lower, and
> assuming you were not performing long array operations such as rebuilds
> or reshapes--if you did so the drives could get hot enough, long enough,
> to be permanently damaged.
> 
>> Maybe thats all academic at this point.  I guess i'll have to rebuild
>> my server from scratch since all my disks seem destroyed and I can't
>> trust the mobo, cpu, or psu.
> 
> Don't start over.  Not just yet.  Leave everything as is for now.
> Simply replace the PSU.  Fire it up and see what you can recover.
> 
>> The psu wasn't dirt cheap, Thermaltake TR2 500w @ $58.  
> 
> The price isn't relevant.  The quality and rail configuration is, and
> whether it's been damaged.  I checked the spec on your TR2-500
> yesterday.  It has dual +12V rails, one rated at 18A and one at 17A.  I
> was unable to locate a wiring diagram for it.  On paper it should have
> plenty of juice for your gear when in working order.  My assumption here
> is that something internal to it may have failed.
> 
>> Should I buy all new
>> everything?  
> 
> I wouldn't.  Most of your gear is probably fine.  Get the PSU swapped
> out and see if that fixes it.  You may still have to wipe the drives and
> build a new array.  You should know pretty quickly if the PSU swap fixed
> the problem, as drives will not continue to drop, or they will.  You
> already have a new mobo in hand, so if the PSU isn't the problem, swap
> the mobo.  That's a good chassis design with good airflow assuming you
> keep the front fans in it.  Why you'd leave them removed is beyond me.
> 
>> If so, while I'm at can you suggest a set of consumer
>> level hardware ideal running a personal mdadm server.  Powered but not
>> overpowered, reliable not bleeding edge.  If I need 6-8 sata ports,
>> should I do onboard or get a controller?
> 
> A new HBA shouldn't be necessary.  But if you choose to go that route
> further down the road I'd recommend an LSI 9211-8i.
> 
>> I still have one backup allthough I'm very nervous now since it's on a
>> 3 disk RAID0, just asking to implode (created in an emergency).
> 
> I assume this resides on a different machine.
> 
> Swap the PSU.  Recover the array if possible.  If not blow it away and
> create new.  If no drives drop out you're probably golden and the PSU
> fixed the problem.  If they drop, swap in the new mobo.  At that point
> you'll have replaced everything that could be the source of the problem
> but for the remaining original drives.  They can't all be bad, if any.
> Always run with those front fans installed.
> 

