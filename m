From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: How to use --freeze-reshape  and is it safe?
Date: Thu, 14 Aug 2014 01:25:28 -0500
Message-ID: <53EC5658.3050708@gmail.com>
References: <53EC4B63.90703@gmail.com> <20140814155633.567baece@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140814155633.567baece@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/14/2014 12:56 AM, NeilBrown wrote:
> On Thu, 14 Aug 2014 00:38:43 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:
>
>> I was browsing through mdadm man pages to check out --layout options
>> when converting 3disk-raid5 to 4disk-raid6 and encountered
>> --freeze-reshape switch/arg. I did a quick google and could not get much
>> info. Can a user issue this to suspend reshape for a short while?
> As --freeze-reshape is only meaningful in combination with --assemble,
> this question doesn't really make sense.
>
> If you are using a sufficiently new kernel and mdadm so that "data_offset" is
> adjusted during reshapes so that no 'backup' is needed, then you can
> suspend a reshape for a period of time by:
>
>    echo frozen > /sys/block/mdXXX/md/sync_action
>
> This is perfectly safe.  When you want to unfreeze, write 'idle'
> to 'sync_action'.  md will notice that a reshape is pending and will restart
> where it was up to.
>
>
>> Specifically
>>
>>   1. Is the use (or frequent use) of this switch safe? recommended?
>>   2. Can the array be mounted when this switch is used?
>>   3. What is correct syntax for the usage?
>>   4. Can I use this to manage the reshape load on an array? May be to let
>>      the disk cool off after a busy hours of seeking to reshape?
>>   5. Can I use it as a safe method for shutting down  the machine?
>>   6. Is there a tutorial/faq/manual that explains in detail the use of
>>      other mdadm esoteric switches? (like --layout I was searching)
> Is it really that esoteric?
> If you want to reshape an array, you run "mdadm --grow" and list all the
> changes you want to make.  Set a new level, a new number of devices, a new
> layout, a new chunk size, whatever.  mdadm will do it if it can and give an
> error if it cannot.
> If you want to test it out first then that is extremely sensible.  Make some
> loop devices and experiment.
>
> NeilBrown
Thanks. The name --freeze-reshape mislead me in to thinking that this is 
a request to stop reshape just like -fail is to make a drive
failed. I used esoteric to mean not routinely used or cannot be 
interpreted by plain English meaning of the the switch/arg name.

While I am at this, let me ask the --layout question also. Does 
conversion from raid5 to raid6 do --layout=left-symmeric-6 first and 
then distribute Q through second pass with --layout=left-symmetric? If 
not, will the reshape be faster if I did it in two phases?

Ramesh

