From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Write intent bitmaps.
Date: Wed, 02 Sep 2009 12:10:42 -0400
Message-ID: <4A9E9902.8050408@tmr.com>
References: <5c45fce80908230116o2f129ab4y8d255cbe83bfac5b@mail.gmail.com>    <87ws4t4bjz.fsf@frosties.localdomain>    <ABFC24E4C13D81489F7F624E14891C860D1F15EF@uk-ex-mbx1.terastack.bluearc.com> <09198ab3b722ad5aa40d32f78626953e.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <09198ab3b722ad5aa40d32f78626953e.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Simon Jackson <sjackson@bluearc.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Tue, August 25, 2009 12:39 am, Simon Jackson wrote:
>   
>> I am trying to use write intent bitmaps on some RAID 1 volumes to reduce
>> the rebuild times in the event of hard resets that cause the md driver to
>> kick members out of my arrays.
>>
>> I used the mdadm --grow /dev/md0 --bitmap=internal  and this appeared to
>> succeed, but when I tried to examine the bitmap I get an error.
>>
>>
>> :~$ sudo mdadm --grow /dev/md0 --bitmap=internal
>> :~$ sudo mdadm -X /dev/md0
>>         Filename : /dev/md0
>>            Magic : 00000000
>> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
>>          Version : 0
>> mdadm: unknown bitmap version 0, either the bitmap file is corrupted or
>> you need to upgrade your tools
>>     
>
> Quoting from the man page:
>
>        -X, --examine-bitmap
>               Report  information about a bitmap file.  The argument is
> either
>               an external bitmap file or an array  component  in  case  of
>  an
>               internal  bitmap.   Note  that  running  this on an array
> device
>               (e.g.  /dev/md0) does not report the bitmap for that array.
>
>
> Particularly read the last sentence.
> Then try
>    mdadm -X /dev/sda5
>   

Well that's nice and clear, but raises the question "why not?" This 
would seem to be one of the most common things someone would do, to look 
at the bitmap for an array.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"Now we have another quarterback besides Kurt Warner telling us during postgame
interviews that he owes every great thing that happens to him on a football
field to his faith in Jesus. I knew there had to be a reason why the Almighty
included a mute button on my remote."
			-- Arthur Troyer on Tim Tebow (Sports Illustrated)

