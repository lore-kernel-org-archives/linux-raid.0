From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Thu, 10 Jun 2010 18:40:11 -0400
Message-ID: <4C1169CB.1030903@meetinghouse.net>
References: <4C1128C2.4020105@meetinghouse.net>	<20100611005743.43664e5b@natsu>	<4C11578B.8010202@meetinghouse.net> <20100611034108.6a2cdbc4@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611034108.6a2cdbc4@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Thu, 10 Jun 2010 17:22:19 -0400
> Miles Fidelman<mfidelman@meetinghouse.net>  wrote:
>
>    
>>> Do you currently have a write intent bitmap in the array? I think it can
>>> reduce the need for recovery by an order of magnitude in some cases. Check
>>> man mdadm for --bitmap if you don't use it yet.
>>>
>>>        
>> Just went through the process of turning it on for all my arrays.
>> Incredibly painless and quick.  Now I get to wait and see if it helps
>> the next time I have a crash/reboot event.
>>      
> I assume you went with "internal" bitmap, in which case if you notice that
> write speed on the arrays became significantly lower, the first thing you
> should look at is increasing the --bitmap-chunk size (I use 131072).
>    
Now you tell me :-)

Yes... went with internal.

I'll keep an eye on write performance.  Do you happen to know, off hand, 
a magic incantation to change the bitmap-chunk size? (Do I need to 
remove the bitmap I just set up and reinstall one with the larger chunk 
size?)
> It is possible to use an external bitmap on an independent device (which has
> almost zero performance impact), but in this case it could be non-trivial to
> 100% ensure that such a device is mounted and accessible at the moment during
> boot-up when md arrays are being started, especially if one of those arrays
> also hosts the root FS.
>    
I think I'll stick with internal.

Thanks again,

Miles


-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


