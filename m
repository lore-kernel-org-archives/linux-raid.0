From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: One raid array does not show up with mdadm --examine --scan
Date: Sat, 20 Mar 2010 17:24:47 -0700
Message-ID: <40b437201003201724m7fd4883cg3f7bbedb281a891b@mail.gmail.com>
References: <40b437201003151113i15ad2a57y3b4f3ac4e18a8ad6@mail.gmail.com>
	 <40b437201003151441t1f2b78cfg901ccae97c893456@mail.gmail.com>
	 <4BA4F486.4020209@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA4F486.4020209@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 20, 2010 at 9:15 AM, Bill Davidsen <davidsen@tmr.com> wrote:
> Simon Matthews wrote:
>>
>> On Mon, Mar 15, 2010 at 11:13 AM, Simon Matthews
>> <simon.d.matthews@gmail.com> wrote:
>>
>>>
>>> On my newly built machine, in which all filesystems are on RAID array,
>>> one of the arrays does not show up with the command:
>>> mdadm --examine --scan
>>>
>>> Why is this? And is there anything I can do to fix it?
>>>
>>
>>
>> I suspect that I may have found an answer to this question -- the
>> array that does not show up is formed from partitions that are logical
>> partitions instead of primary partitions. I'll try deleting the
>> partitions and re-creating as primary.
>>
>>
>
> That's not it, I just checked and mine show up just fine, even with an old
> kernel and mdadm.

I have destroyed and re-created the arrays and the problem has gone away.

Simon
