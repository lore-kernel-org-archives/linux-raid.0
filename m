From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: PROBLEM: system crash on AMD64 with 2.6.17.11 while accessing
 3TB Software-RAID5
Date: Mon, 04 Sep 2006 13:06:34 -0400
Message-ID: <44FC5D1A.6020809@tmr.com>
References: <758194931.20060829001041@TU-Ilmenau.de> <17654.24059.852752.251958@cse.unsw.edu.au> <44F6E962.40900@TU-Ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44F6E962.40900@TU-Ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ralf Herrmann <Ralf.Herrmann@TU-Ilmenau.de>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ralf Herrmann wrote:

> Dear Mr.Brown,
>
>> Yes...... you are hitting some pretty serious BUGs.  And this is in
>> code that is not specific to RAID at all, so if there really were bugs
>> there, we would expect to have seen them well before now.
>
>
> Your are absolutely right, it doesn't seem to be in RAID at all,
> but as of now, it only happened when doing something with /dev/md0.
>
>
>> I really looks to me like a hardware problem.  Some how various bits
>> of memory sometimes have bad values and cause a problem.
>>
>> How long did you run memtest?  I would suggest running it for at
>> least 24 hours, because my best guess is that it is bad memory, even
>> though your tests so far don't show that.
>
>
> I ran it for about 16h, with all tests enabled, no error occured.
>
> I was always wondering why it worked before the change and
> not now. The only difference were the larger drives. And i've read so 
> many reports
> of people running much larger RAID5 partitions than we do,
> so why should it fail in this case?
>
> So my best bet at the moment, would be a hardware problem, too.
> I continued looking at the kernel oops messages and sometimes
> disassembly of the code where it broke gave invalid opcodes.
> This also looks pretty much like a hardware issue.
> But tests of single components did not unvail any error.....
>
> It seems to me, that it only happens, when many system components
> are involved, several HDDs, the whole RAM, the NIC and so on.
> That leads me to another idea i'm currently testing.
>
> It could very well be a bad power supply.
> Maybe this box was running at full load of the power supply before,
> and now with new drives consumes more power the supply can deliver,
> if all system components are used at once.
> I switched to a better power supply, tests are running as i write this.
>
> I'm sorry if i wasted your time, i should have checked this before
> writing to the list. But power supply problems are pretty odd
> and hard to identify. Anyways, i'm not sure if that solves the problem.
>
> Ok, i'll write the results of current tests, when they are finished.
>
> Thanks for your consideration. 

It certainly is a legitimate question, and marginal power would have 
been at the end of my list as well... However, if all else fails, try 
formatting the new drives to use only the size of the old drive capacity 
(RAID on small partitions) and see if that works. If so you may have 
found some rare size-related bug.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

