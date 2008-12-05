From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 5 Dec 2008 16:17:00 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812051615470.17806@p34.internal.lan>
References: <1228510833.16555.76.camel@localhost>  <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>  <1228511195.16555.78.camel@localhost>  <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan> <1228511558.16555.84.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228511558.16555.84.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 5 Dec 2008, Redeeman wrote:

> On Fri, 2008-12-05 at 16:09 -0500, Justin Piszcz wrote:
>>
>> On Fri, 5 Dec 2008, Redeeman wrote:
>>
>>> On Fri, 2008-12-05 at 16:02 -0500, Justin Piszcz wrote:
>>>>
>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>
>>>>> Hello.
>>>>>
>>>>> I was looking at the PDFs linked to from the wiki, and found this:
>>>>> http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
>>>>>
>>>>> More specifically, section 4, starting on page 8.
>>>>>
>>>>> Am I understanding this correctly, in that with raid6, linux is capable
>>>>> of detecting if the content on 1 disk is corrupted, and reconstruct it
>>>>> from the remaining disks?
>>>>
>>>> I ran md/raid6 for awhile, do you mean remap the bad sector on the fly?
>>>> Linux/md raid does not do this afaik.
>>>
>>> No, i mean, if one disk does silent corruption
>>
>> What would the error look like?  Both md/Linux & in the 3ware manual
>> recommend you run a 'check' across the raid at least once a week
>> (3ware/raid-verify) and md/Linux in Debian runs a check once a month I
>> believe to eliminate these issues.
>>
>> If you are asking whether a read error of a latent sector from the one
>> disk will result it reading the data from the second disk that is a good
>> question.
>
> im asking, if one disk in a raid6 setup suddenly decides to flip a few
> bits in some bytes, will it be able to detect that in a scan, and
> correct it? i cant see how it can do it on raid5, but maybe raid6?
I have never seen any kernel messages showing md/raid: fixed sector 29383 
for example and I have had 8-9 RMA's with Western Digital for bad/failed 
velociraptors in RAID6, I had go with raid6 because it is so bad that 
sometimes 2 drives at a time would drop out of the array.  However, for 
the instances where there were just problems with one drive, it kicked it 
out of the array and the raid6 became degraded.
