From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 09:58:53 -0400
Message-ID: <49E9DC9D.5050708@tmr.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:
> On Apr 16, 2009, at 11:49 PM, Neil Brown wrote:
>> On Monday April 6, dledford@redhat.com wrote:
>>> On Apr 1, 2009, at 6:46 PM, Neil Brown wrote:
>>>
>>>> On Wednesday April 1, jnelson-linux-raid@jamponi.net wrote:
>>>>> ping?
>>>>
>>>> Oh yeah, that's right, I was going to reply to that - thanks for the
>>>> reminder.
>>>>
>>>>>
>>>>> On Tue, Mar 24, 2009 at 11:57 AM, Jon Nelson
>>>>> <jnelson-linux-raid@jamponi.net> wrote:
>>>>>>
>>>>>> I have a raid1 comprised of a local physical device (/dev/sda) and a
>>>>>> network block device (/dev/nbd0).
>>>>>> When the machine hosting the network block device comes up, however,
>>>>>> it creates /dev/md127.
>>>>>> Why?
>>>>
>>>> Because you cannot please all the people, all the time.
>>>
>>> Very true.
>>
>> And I fear I'm going to be displeasing again :-(
>>
>>>
>>>>
>>>> People seem to want their arrays to auto-assemble - you know, just
>>>> appear and do the right thing, read their mind probably, because
>>>> creating config files is too hard.
>>>> So I've endeavoured to make that happen.
>>>>
>>>> The biggest problem with auto-assembly is what to do if two arrays
>>>> claim to have the same name. (e.g. /dev/md0) - which one wins.
>>>> The 'homehost' is (currently) used to resolve that.  An array only
>>>> gets to use the name it claims to have if it can show that it belongs
>>>> to "this" host.  If it doesn't it still get assembled, but with some
>>>> other more generic name.
>>>
>>> FWIW, I happen to disagree with this method.  And I'm currently
>>> testing out a new algorithm for this in Fedora 11 beta.
>>
>> Thank you for explaining this in such detail.
>> There are aspects of it that I don't like, but I think there might be
>> pieces that I can take away from it too.
>>
>> As you probably know, my preferred solution is to have all arrays
>> listed in /etc/mdadm.conf.  If it isn't in mdadm.conf, it doesn't get
>> assembled.   But I don't have a lot of company in this opinion.  Lots
>> of people want to have arrays assembled without them being in
>> mdadm.conf, and I'm trying to work with that.
>
> This appears to be the difference between a server setup and a desktop 
> setup.  Server admins want to list things and only have known actions 
> happen.  Desktop people want things to "just work".  I've had several 
> people tell me they thought the idea of mdadm.conf was completely out 
> of date and it should just go away entirely.  Not saying I agree, just 
> letting you know what I get.
>
>> Parts of what you are proposing seem to involve expecting people to
>> take a middle ground with some arrays listed in mdadm.conf and other
>> that aren't.
>
> I do this myself FWIW.  My / and /boot arrays are in mdadm.conf, but 
> arrays that I plug in via USB, eSATA, etc. are not.

Similar here, I have arrays which should not be assembled without 
explicit request, for various reasons, including some which have 
passwords on the filesystem, and some which are mutually exclusive (test 
and production, 32/64 bit setups, etc).

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


