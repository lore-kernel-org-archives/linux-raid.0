From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: One raid array does not show up with mdadm --examine --scan
Date: Sat, 20 Mar 2010 12:15:02 -0400
Message-ID: <4BA4F486.4020209@tmr.com>
References: <40b437201003151113i15ad2a57y3b4f3ac4e18a8ad6@mail.gmail.com> <40b437201003151441t1f2b78cfg901ccae97c893456@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40b437201003151441t1f2b78cfg901ccae97c893456@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Simon Matthews wrote:
> On Mon, Mar 15, 2010 at 11:13 AM, Simon Matthews
> <simon.d.matthews@gmail.com> wrote:
>   
>> On my newly built machine, in which all filesystems are on RAID array,
>> one of the arrays does not show up with the command:
>> mdadm --examine --scan
>>
>> Why is this? And is there anything I can do to fix it?
>>     
>
>
> I suspect that I may have found an answer to this question -- the
> array that does not show up is formed from partitions that are logical
> partitions instead of primary partitions. I'll try deleting the
> partitions and re-creating as primary.
>
>   
That's not it, I just checked and mine show up just fine, even with an 
old kernel and mdadm.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

