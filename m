From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: add man page for --add-journal
Date: Mon, 15 Aug 2016 10:42:30 -0400
Message-ID: <wrfj60r25c15.fsf@redhat.com>
References: <1470960604-2852450-1-git-send-email-songliubraving@fb.com>
	<wrfjshua825o.fsf@redhat.com>
	<defa4365-a771-f4e8-4375-b67bc933767b@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <defa4365-a771-f4e8-4375-b67bc933767b@websitemanagers.com.au>
	(Adam Goryachev's message of "Sat, 13 Aug 2016 15:13:47 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org, yizhan@redhat.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

Adam Goryachev <mailinglists@websitemanagers.com.au> writes:
> On 13/08/2016 00:58, Jes Sorensen wrote:
>> Song Liu <songliubraving@fb.com> writes:
>>> Add the following to man page:
>>>
>>> --add-journal
>>>        Recreate journal for RAID-4/5/6 array that losts journal
>>>        devices. In current implementation, this command cannot
>>>        add journal to an array that had failed journal.  To
>>>        avoid  interrupting  on-going  write  opertions,
>>>        --add-journal only works for array in Read-Only state.
>>>
>>> Reported-by: Yi Zhang <yizhan@redhat.com>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> Signed-off-by: Shaohua Li <shli@fb.com>
>>> ---
>>>   mdadm.8.in | 8 ++++++++
>>>   1 file changed, 8 insertions(+)
>> Applied, with a few minor mods.
>>
>> I changed it to say this, I hope you are fine with that:
>>
>> "Recreate journal for RAID-4/5/6 array that lost a journal device. In the
>> current implementation, this command cannot add a journal to an array
>> that had a failed journal. To avoid interrupting on-going write
>> opertions, "
> I think this might be more correct:
>
> "Recreate journal for RAID-4/5/6 array that lost a journal device. In the
> current implementation, this command cannot add a journal to an array
> that *has* a failed journal. To avoid interrupting on-going write
> *operations*, "
>
>
> Note the two words modified have **
> has mean currently, if it had (past) a failed journal, but that has
> already been fixed, then it currently has a working journal, and so I
> assume this patch is not relevant. It's only related to if the array
> is currently missing a journal...
> The second operations is just a typo...
>
> Hope you don't mind my jumping in here, I can't help much with code,
> but hopefully contribution is still helpful.

If Song is happy with this and you send me a patch, I'll be happy to
apply it.

Cheers,
Jes
