From: Tim Bostrom <tbostrom@writemem.com>
Subject: Re: Problem with 5disk RAID5 array - two drives lost
Date: Tue, 25 Apr 2006 07:55:41 -0700
Message-ID: <A5A54E65-D1A6-4D88-8145-9825673CB544@writemem.com>
References: <A2F915E2-EC52-4EFE-86C2-547A71F8D788@writemem.com>	 <62b0912f0604212054m40283fdbybdb6cd89e61dd153@mail.gmail.com>	 <A6B7149E-FC1E-4779-8370-66AF285F58A0@writemem.com> <1145844022.9213.1.camel@profit> <444CDA1D.2020102@dgreaves.com>
Mime-Version: 1.0 (Apple Message framework v749.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444CDA1D.2020102@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Arthur Britto <ahbritto@iat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, so 952 errors (about 450k) and 25+ hours later, I have a copy of  
the hdf drive on a brand new 250GB drive thanks to dd_rescue.

I haven't tried swapping it to the array.  That's the next step.  I  
imagine, I'll be able to mdadm --assemble --force and have it take  
the 4 drives into the array.  Dare I mount it after this or is there  
some troubleshooting I should do before a mount?

-Tim



On Apr 24, 2006, at 7:01 AM  Apr 24, 2006, David Greaves wrote:

> Arthur Britto wrote:
>> On Sun, 2006-04-23 at 17:17 -0700, Tim Bostrom wrote:
>>> I bought two extra 250GB drives - I'll try using dd_rescue as
>>> recommended and see if I can get a "good" copy of hdf online.
>>
>> You might want to use dd_rhelp:
>> http://www.kalysto.org/utilities/dd_rhelp/index.en.html
> Having used both dd_rescue/dd_rhelp and the gnu ddrescue in anger, I'd
> suggest gnu ddrescue.
>
> http://www.gnu.org/software/ddrescue/ddrescue.html
>
> David
>
> -- 
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

