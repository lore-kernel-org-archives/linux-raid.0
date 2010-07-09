From: Marek <mlf.conv@gmail.com>
Subject: Re: Linux/MacOSX RAID5 dual boot
Date: Fri, 9 Jul 2010 13:57:43 +0200
Message-ID: <76C57574-FBB3-4035-BA7B-ADA3342387A4@gmail.com>
Mime-Version: 1.0 (iPhone Mail 7E18)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9.7.2010, at 13:29, Neil Brown <neilb@suse.de> wrote:

> On Fri, 9 Jul 2010 13:15:00 +0200
> Marek <mlf.conv@gmail.com> wrote:
>
>> Hi Neil,
>>
>> thanks for your answer. Do I understand it correctly that porting the
>> md driver wouldn't be an option either?
>
> No, not really an option.
> Darwin is sufficiently different from Linux that it would really  
> mean writing
> a RAID5 driver for Darwin using md as a guide.  You could probably  
> borrow
> some code (if the license allowed it which I doubt) but a very large  
> amount
> would need to be written from scratch.

thanks for the information. It seems that a software RAID solution 
(other than RAID1 or RAID0) for OSX doesn't exist. I was only able to  
find SoftRAID which has some interesting features that are probably  
outside the scope of mdadm, but they don't even support RAID5 yet.

Marek
>
>
>>
>> Marek
>>
>> On 9.7.2010, at 12:22, Neil Brown <neilb@suse.de> wrote:
>>
>>> On Fri, 9 Jul 2010 12:07:56 +0200
>>> Marek <mlf.conv@gmail.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> it seems that my email has hit top 5 ranking on google when  
>>>> searching
>>>> for "mdadm macosx", but it seems that due to some heavy  
>>>> discussion on
>>>> this mailing list it probably went unnoticed.
>>>> I would like to ask if someone would be able to elaborate whether
>>>> there is a possibility that mdadm would run on Darwin and if so,
>>>> whether a port would require a substantial rewrite.
>>>
>>> mdadm would not run on Darwin.  It only works with the 'md' driver
>>> which is
>>> only in Linux.
>>>
>>> If you want both Linux and Darwin to be able to access the same
>>> software RAID
>>> array, you would need to find a format that both understand.
>>> Probably the easiest way would be do discover how MAC OSX formats
>>> RAID array
>>> and write support for that in mdadm.  Far from trivial, but probably
>>> possible.
>>>
>>> A quick google suggest that RAID5 is not supported in OSX, so that
>>> would not
>>> be an option.
>>>
>>> NeilBrown
>

