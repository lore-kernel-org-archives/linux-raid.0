From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Mon, 14 Apr 2008 12:38:06 -0400
Message-ID: <4803886E.3050007@tmr.com>
References: <48025B8D.2030803@harddata.com> <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan> <4802AFEB.9020006@tmr.com> <4802CDA2.605@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4802CDA2.605@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maurice Hilarius wrote:
> Bill Davidsen wrote:
>> ..
>>>> I am pretty sure that one of the drives has developed some issues 
>>>> and needs to be replaced.
>>>> ..
>>
>> Very unexpected that the data would be bad without any hardware errors. 
> I DID say:
> "I am pretty sure that one of the drives has developed some issues and 
> needs to be replaced. "
>> Did you look at your logs to see if one of your drives, or perhasps 
>> both, are getting hardware errors?
> Oh, I KNOW one does..
> The question is WHICH one?
>
I no longer have any old logs showing errors, but /var/log/messages 
and/or dmesg should have an error message with a drive identification if 
you are getting disk errors.
>> I would run a 'check' and and see what mdadm finds on the array, you 
>> may have other problems.
>>
> Pardon my stupidity, care to share some syntax for that?

cd /sys/block/md0/md
echo check >sync_action; cat mismatch_cnt

That's the count of errors found. Replace 'check' with 'repair' to make 
the errors go away, reboot, run 'check' again.

>> Actually, I think I would run memtest86 for at least a few hours, 
>> starting from a really cold system (not just a cold boot, off for a 
>> few hours).
> Did that already.
>> Your comment "on boot" may come from memory or other component which 
>> needs to physically get up to temperature before working reliably. 
>> Particularly if you don't get additional errors after you have been 
>> up for a while.
>>
> It happens cold or hot.
>
>
> -- 
> Regards, Maurice
>


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


