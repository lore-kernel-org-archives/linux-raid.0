From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Is this likely to cause me problems?
Date: Tue, 21 Sep 2010 23:34:26 +0100
Message-ID: <4C9932F2.1090201@anonymous.org.uk>
References: <213127.13825.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <213127.13825.qm@web51307.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/09/2010 22:18, Jon Hardcastle wrote:
> --- On Tue, 21/9/10, John Robinson<john.robinson@anonymous.org.uk>  wrote:
>
>> From: John Robinson<john.robinson@anonymous.org.uk>
>> Subject: Re: Is this likely to cause me problems?
>> To: Jon@eHardcastle.com
>> Cc: linux-raid@vger.kernel.org
>> Date: Tuesday, 21 September, 2010, 22:15
>> On 21/09/2010 21:33, Jon Hardcastle
>> wrote:
>>> I am finally replacing an old and now failed drive
>> with a new one.
>>>
>>> I normally create a partition the size of the entire
>> disk and add that but whilst checking the sizes marry up i
>> noticed that is an odity...
>>>
>>> Below is an fdisk dump of all the drives in my RAID6
>> array
>>>
>>> sdc---
>>> /dev/sdc1
>> 2048
>> 1953525167   976761560   fd
>> Linux raid autodetect
>>> ---
>>> Seems to be different to sda say which is also '1TB'
>>>
>>> sda---
>>> /dev/sda1
>>    63
>> 1953520064   976760001   fd
>> Linux raid autodetect
>>> ---
>>>
>>> Now i read somewhere that the sizes flucuate but as
>> some core value remains the same can anyone confirm if this
>> is the case?
>>>
>>> I am reluctant to add to my array until i know for
>> sure...
>>
>> Looks like you've used a different partition tool on the
>> new disc than you used on the old ones - old ones started
>> the first partition at the beginning of cylinder 1, new ones
>> like to start partitions at 1MB so they're aligned on 4K
>> sector boundaries and SSDs' erase group boundaries etc. You
>> could duplicate the original partition table like this:
>>
>> sfdisk -d /dev/older-disc | sfdisk /dev/new-disc
>>
>> But it wouldn't cause you any problems, because the new
>> partition is bigger than the old one, despite starting a
>> couple of thousand sectors later. This in itself is odd -
>> how did you come to not use the last chunk of your original
>> discs?
>>
>> Cheers,
>>
>> John.
>>
>> --
>
> I used fdisk in all cases.. on the same machine.. so unless fdisk has changed?

May have done. Certainly my util-linux from CentOS 5 is newer than the 
last version of util-linux on freshmeat.net and kernel.org. Peeking at 
the source code, it looks like Red Hat have been patching util-linux 
themselves for almost 5 years.

> primary... 1 partition.. default start and end.
>
> and what do you mean about not using the last chunk of old disc?

Your sda has 1953525168 sectors but your partition ends at sector 
1953520064, 5104 sectors short of the end of the disc. This may be 
related to the possible bug somebody complains about on freshmeat.net 
whereby fdisk gets the last cylinder wrong. I just checked, on my 1TB 
discs I have the same end sector as you so I guess the fdisk I had when 
I built my array was the same as yours when you built yours.

Cheers,

John.
