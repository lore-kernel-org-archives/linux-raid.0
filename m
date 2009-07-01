From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Adding a smaller drive
Date: Wed, 01 Jul 2009 14:53:23 -0400
Message-ID: <4A4BB0A3.6050401@tmr.com>
References: <20090628194705152.ITZI24524@cdptpa-omta02.mail.rr.com>	 <4A4A4506.1070003@tmr.com> <87f94c370906301122p404c5cbcg61a8dfa81ee78594@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370906301122p404c5cbcg61a8dfa81ee78594@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Freemyer wrote:
> On Tue, Jun 30, 2009 at 1:01 PM, Bill Davidsen<davidsen@tmr.com> wrote:
>   
>> Leslie Rhorer wrote:
>>     
> <snip>
>   
>>>        I may have to rethink my position on using raw drives.  If I
>>> partition the drives, I can make the partition a bit smaller than the
>>> whole
>>> drive, allowing for the addition of a future drive whose size is a bit
>>> off.
>>> I hate to waste space, but being stuck with an undersized or limping array
>>> is worse.
>>>
>>>       
>> Some manufacturers use the HPA (host protected area) to reduce the size
>> available to the user. You will see reference to this in the dmesg output.
>> There is a tool to let you see/set HPA, but I can't put my hand on the info
>> right now, the one I have is out of date, so I won't mention it.
>>     
>
> Any recent version of hdparm can get/set HPA for LBA-48 drives.  That
> feature went in a couple years ago. And it is the only tool I know
> that works with LBA-48 drives.  (ie. drives larger than 128 GiB).
>
> If your version is too old you can get a new version off of
> sourceforge I believe.
>   

I was actually thinking of a GUI tool, used for partition management, 
but I can't recall the name (I do most things like that from the cli). 
There's also SleuthKit, which may handle larger drives, 1TB limit comes 
to mind, but I was using it for something else rather than HPA.

In any case, some drives seem to use that for sizing, just wanted to 
note that to the O.P.

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

