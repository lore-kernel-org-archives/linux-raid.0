From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: [PATCH] mdadm: add man page for --add-journal
Date: Sat, 13 Aug 2016 15:13:47 +1000
Message-ID: <defa4365-a771-f4e8-4375-b67bc933767b@websitemanagers.com.au>
References: <1470960604-2852450-1-git-send-email-songliubraving@fb.com>
 <wrfjshua825o.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjshua825o.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, yizhan@redhat.com, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids



On 13/08/2016 00:58, Jes Sorensen wrote:
> Song Liu <songliubraving@fb.com> writes:
>> Add the following to man page:
>>
>> --add-journal
>>        Recreate journal for RAID-4/5/6 array that losts journal
>>        devices. In current implementation, this command cannot
>>        add journal to an array that had failed journal.  To
>>        avoid  interrupting  on-going  write  opertions,
>>        --add-journal only works for array in Read-Only state.
>>
>> Reported-by: Yi Zhang <yizhan@redhat.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> Signed-off-by: Shaohua Li <shli@fb.com>
>> ---
>>   mdadm.8.in | 8 ++++++++
>>   1 file changed, 8 insertions(+)
> Applied, with a few minor mods.
>
> I changed it to say this, I hope you are fine with that:
>
> "Recreate journal for RAID-4/5/6 array that lost a journal device. In the
> current implementation, this command cannot add a journal to an array
> that had a failed journal. To avoid interrupting on-going write
> opertions, "
I think this might be more correct:

"Recreate journal for RAID-4/5/6 array that lost a journal device. In the
current implementation, this command cannot add a journal to an array
that *has* a failed journal. To avoid interrupting on-going write
*operations*, "


Note the two words modified have **
has mean currently, if it had (past) a failed journal, but that has 
already been fixed, then it currently has a working journal, and so I 
assume this patch is not relevant. It's only related to if the array is 
currently missing a journal...
The second operations is just a typo...

Hope you don't mind my jumping in here, I can't help much with code, but 
hopefully contribution is still helpful.

Regards,
Adam
> If I botched it up please let me know.
>
> Jes
>
>
>> diff --git a/mdadm.8.in b/mdadm.8.in
>> index 1a04bd1..a335c53 100644
>> --- a/mdadm.8.in
>> +++ b/mdadm.8.in
>> @@ -1444,6 +1444,14 @@ number. The receiving node must acknowledge this message
>>   with \-\-cluster\-confirm. Valid arguments are <slot>:<devicename> in case
>>   the device is found or <slot>:missing in case the device is not found.
>>   
>> +.TP
>> +.BR \-\-add-journal
>> +Recreate journal for RAID-4/5/6 array that losts journal devices. In current
>> +implementation, this command cannot add journal to an array that had failed
>> +journal. To avoid interrupting on-going write opertions,
>> +.B \-\-add-journal
>> +only works for array in Read-Only state.
>> +
>>   .P
>>   Each of these options requires that the first device listed is the array
>>   to be acted upon, and the remainder are component devices to be added,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

