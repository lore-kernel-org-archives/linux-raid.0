From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Thu, 10 Jun 2010 17:22:19 -0400
Message-ID: <4C11578B.8010202@meetinghouse.net>
References: <4C1128C2.4020105@meetinghouse.net> <20100611005743.43664e5b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611005743.43664e5b@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Thu, 10 Jun 2010 14:02:42 -0400
> Miles Fidelman<mfidelman@meetinghouse.net>  wrote:
>
>    
>> 2.  Are there any settings that can reduce the likelihood of a RAID
>> volume being dirty after a crash?  (The crash/reboot isn't that much of
>> a problem - the several hours of degraded performance ARE a problem.)
>>      
> Do you currently have a write intent bitmap in the array? I think it can
> reduce the need for recovery by an order of magnitude in some cases. Check man
> mdadm for --bitmap if you don't use it yet.
>    
Just went through the process of turning it on for all my arrays.  
Incredibly painless and quick.  Now I get to wait and see if it helps 
the next time I have a crash/reboot event.

Thanks very much!

Miles


-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


