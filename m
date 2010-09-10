From: Norman White <nwhite@stern.nyu.edu>
Subject: Re: 5 drives lost in an inactive  15 drive raid 6 system due to cable
 problem - how to recover?
Date: Fri, 10 Sep 2010 11:18:23 -0400
Message-ID: <4C8A4C3F.4050109@stern.nyu.edu>
References: <4C87C656.2030405@stern.nyu.edu> <20100909073530.1e5da34d@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100909073530.1e5da34d@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  On 9/8/2010 5:35 PM, Neil Brown wrote:
> On Wed, 08 Sep 2010 13:22:30 -0400
> Norman White<nwhite@stern.nyu.edu>  wrote:
>
>> We have a 15 drive addonics array with 3 5 port sata multiplexors, one
>> of the sas cables was knocked out to one of the port multiplexors and now
>> mdadm sees 9 drives , a spare, and 5 failed, removed drives (after
>> fixing the cabling problem).
>>
>> A mdadm -E on each of the drives, see 5 drives (the ones that were
>> uncabled) as seeing the original  configuration with 14 drives and a
>> spare, while the other 10 drives report
>> 9 drives, a spare and 5 failed , removed drives.
>>
>> We are very confident that there was no io going on at the time, but are
>> not sure how to proceed.
>>
>> One obvious thing to do is to just do a:
>>
>> mdadm --assemble --force --assume-clean /dev/md0 sd[b,c, ... , p]
>> but we are getting different advice about what force will do in this
>> situation. The last thing we want to do is wipe the array.
> What sort of different advice?  From whom?
>
> This should either do exactly what you want, or nothing at all.  I suspect
> the former.  To be more confident I would need to see the output of
>     mdadm -E /dev/sd[b-p]
>
> NeilBrown
>
>


Just to close this out, I sent Neil Brown the output of mdadm -E 
/dev/sd[b-p]
and he agreed it looked clean.

I then did an
mdadm --assemble --force /dev/md0 sd[b-p]

and got the message /dev/sdb was busy, no super block.

Rebooted the system, and reissued the mdadm --assemble --force.

Voila,
/dev/md0 was back.. Initial tests indicate no data loss.

We have, of course, (as suggested by some on this list), more securely 
attached the sas
cables to the back of the addonics array so this can't happen again. The 
siIicon image
port multiplers only seem to have  push in connections that don't lock 
at all. Just a pressure fit. We
have to be very careful working around the box.

On the other hand, we have a 30TB raid 6 array (about 21 TB formatted 
with a hot spare) that is extremely fast and inexpensive. (~ $4k ).
We are considering buying another and having a dedicated server  with 
several  arrays connected to it and put in a protected environment.

Thank you very much Neil.

We owe you.

Best,
Norman White
>> Another option would be to fiddle with the super blocks with mddump, so
>> that they all see the same 15 drives in the same configuration, and then
>> assemble it.
>>
>> Yet another suggestion was to recreate the array configuration and hope
>> that the data wouldn't be touched.
>>
>> And even another suggestion is to create the array with one drive
>> missing (so it is degraded and won't rebuild)
>>
>> Any pointers on how to proceed would be helpful. Restoring 30TB takes
>> along time.
>>
>> Best,
>> Norman White
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

