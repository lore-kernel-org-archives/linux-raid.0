From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 reconstruction ?
Date: Tue, 02 Jun 2009 14:42:47 -0400
Message-ID: <4A2572A7.6030901@tmr.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>	<4A213612.7080206@anonymous.org.uk>	<1243699735.5740.103.camel@localhost> <878wkezagw.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878wkezagw.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Redeeman <redeeman@metanurb.dk>, John Robinson <john.robinson@anonymous.org.uk>, SandeepKsinha <sandeepksinha@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Redeeman <redeeman@metanurb.dk> writes:
>
>   
>> On Sat, 2009-05-30 at 14:35 +0100, John Robinson wrote:
>>     
>>> On 30/05/2009 06:44, SandeepKsinha wrote:
>>>       
>>>> Hi all,
>>>>
>>>> Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
>>>>
>>>> I have data of 5GB. When a disk fails and replaced with a spare disk.
>>>> Will the reconstruction happen only for the 5GB allocated disk blocks
>>>> or it will happen for the whole disk size.
>>>>         
>>> The whole disc size, for now anyway; md does not currently note which 
>>> blocks have been used by its client (the filesystem, LVM, whatever).
>>>
>>>       
>>>> Is it possible to make  reconstruction intelligent enough to keep it optimized ?
>>>>         
>>> This has been discussed in combination with supporting SSD drives' TRIM 
>>> function, and would mean md had to keep track of used chunks or possibly 
>>> even sectors using a bitmap or something like that, but whether anyone's 
>>> working on it I don't know.
>>>       
>> I would say it should be possible to 'query' the filesystem for that
>> information. Obviously this will only work if you run a filesystem on it
>> which supports it, but it would seem like a nicer solution than a bitmap
>> for it.
>>
>>     
>>> Cheers,
>>>
>>> John.
>>>       
>
> And just when I hit send I thought of something else.
>
> Instead of the initial sync when creating a raid the bitmap could just
> mark all blocks as unused. Much faster raid creation.
>   

That sounds a lot like what I mentioned, therefore it must be right. See 
the thread on sync on a new array, my reply to Neil.

-- 
Bill Davidsen <davidsen@tmr.com>
  Even purely technical things can appear to be magic, if the documentation is
obscure enough. For example, PulseAudio is configured by dancing naked around a
fire at midnight, shaking a rattle with one hand and a LISP manual with the
other, while reciting the GNU manifesto in hexadecimal. The documentation fails
to note that you must circle the fire counter-clockwise in the southern
hemisphere.


