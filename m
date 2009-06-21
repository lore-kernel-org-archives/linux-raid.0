From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Subject: Raid0 Reshape . Preface
Date: Sun, 21 Jun 2009 14:19:11 -0400
Message-ID: <4A3E799F.8040305@tmr.com>
References: <1245189072.3478.92.camel@raz>	<19000.55700.831349.967378@notabene.brown>	<51950.194.105.184.77.1245241039.squirrel@www.yuiop.co.uk> <19001.28349.151553.26110@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19001.28349.151553.26110@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday June 17, john.robinson@anonymous.org.uk wrote:
>   
>> On Wed, June 17, 2009 12:55 pm, Neil Brown wrote:
>>     
>>>  The more I think about it, the more I feel I would prefer to use the
>>>  raid5 module for all restriping.
>>>       
>> That doesn't make sense to me, for various reasons including those for
>> having separate RAID personality modules in the first place. On the other
>> hand, if you're keeping the raid0 module simple, perhaps the raid5 module
>> could also be simplified and all objectives could be served by shipping
>> out all restriping to a new, separate restriping module? Or even to
>> userspace?
>>     
>
> The enhancements needed to raid5 to make is able to handle reshaping a
> raid0 are either minor, or are ones that we want eventually any way.
> Given that, there seems little point implementing the same thing in
> two different ways.
>
> I have occasionally thought that it would be nice if all the "Reshape"
> code could be separated out of raid5 as it is not used very often.
> However I suspect that you would find that it isn't very much code as
> it shares a lot with resync and normal raid5 processing.
>
> Striping it out into user-space is also tempting.  The tricky bit
> would be deciding on the interface - exactly how much to leave in the
> kernel and how much to takeout.  It might be an interesting exercise.
> It's hard to know if it would be productive or not.
>   

Render unto Caesar what is Caesar's, etc. I don't think anything 
critical like that should be in user space, it invites people to try to 
"improve it" and really mess up their data, then come looking for help. 
At least by raising the bar to require being able to build a kernel you 
eliminate some people who probably shouldn't be doing that.

On the other hand, putting reshape into a module which could be loaded 
if needed or enhanced and inserted for testing might be a good idea. It 
just seems easier to have kernel code than to try to make user code do 
the right thing in terms of keeping things resident, running with 
appropriate priorities, etc.

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

