From: Tim Bostrom <tbostrom@writemem.com>
Subject: Re: Problem with 5disk RAID5 array - two drives lost
Date: Tue, 25 Apr 2006 23:19:33 -0700
Message-ID: <7B593E38-7D8D-4D4B-91D1-A3F084F85CB0@writemem.com>
References: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com>	 <62b0912f0604212054m40283fdbybdb6cd89e61dd153@mail.gmail.com>	 <A6B7149E-FC1E-4779-8370-66AF285F58A0@writemem.com> <1145844022.9213.1.camel@profit> <444CDA1D.2020102@dgreaves.com> <A5A54E65-D1A6-4D88-8145-9825673CB544@writemem.com>
Mime-Version: 1.0 (Apple Message framework v749.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A5A54E65-D1A6-4D88-8145-9825673CB544@writemem.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@writemem.com>
Cc: David Greaves <david@dgreaves.com>, Arthur Britto <ahbritto@iat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just wanted to thank all of you who helped me with this problem.

dd_rescue was the ticket.  I used Knoppix and dd_rescue to copy the  
entire /dev/hdf drive to a brand new drive.  Took almost 36 hours to  
copy 250GB.  After that, I replaced hdf with the new drive and  
rebooted the machine back to FC4.  I then mdadm --assemble --force  
and then mounted the drive.  All the data seems to be there (or at  
least the data I cared about).  Next, I installed a new drive to  
replace the first failed drive (/dev/hdh) and then began the  
rebuilding process.  Everything seems OK for now.

Thank you all, again.



On Apr 25, 2006, at 7:55 AM  Apr 25, 2006, Tim Bostrom wrote:

> OK, so 952 errors (about 450k) and 25+ hours later, I have a copy  
> of the hdf drive on a brand new 250GB drive thanks to dd_rescue.
>
> I haven't tried swapping it to the array.  That's the next step.  I  
> imagine, I'll be able to mdadm --assemble --force and have it take  
> the 4 drives into the array.  Dare I mount it after this or is  
> there some troubleshooting I should do before a mount?
>
> -Tim
>
>
>
> On Apr 24, 2006, at 7:01 AM  Apr 24, 2006, David Greaves wrote:
>
>> Arthur Britto wrote:
>>> On Sun, 2006-04-23 at 17:17 -0700, Tim Bostrom wrote:
>>>> I bought two extra 250GB drives - I'll try using dd_rescue as
>>>> recommended and see if I can get a "good" copy of hdf online.
>>>
>>> You might want to use dd_rhelp:
>>> http://www.kalysto.org/utilities/dd_rhelp/index.en.html
>> Having used both dd_rescue/dd_rhelp and the gnu ddrescue in anger,  
>> I'd
>> suggest gnu ddrescue.
>>
>> http://www.gnu.org/software/ddrescue/ddrescue.html
>>
>> David
>>
>> -- 
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

