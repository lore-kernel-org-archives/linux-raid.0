From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID Problem
Date: Sat, 20 Mar 2010 12:55:19 -0400
Message-ID: <4BA4FDF7.8000401@tmr.com>
References: <Gophermail.2.0.1003161832390.28616@vs-a.tc.umn.edu> <20100317110943.793c8e7b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100317110943.793c8e7b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: colli419@umn.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On 16 Mar 2010 18:32:39 -0500
> colli419@umn.edu wrote:
>
>   
>> Hello, I am having problems with my RAID as follows:
>>
>> I installed the drives in an old computer and created the RAID and it 
>> worked great. When I tried to install the same RAID set in a new computer I 
>> could get it to mount manually with some messing around but couldn't get it 
>> to mount automatically as in the old machine. I was wondering if zeroing 
>> the superblocks and trying to re-create the RAID would be a good idea. The 
>> data that is stored on the drives should otherwise be intact because I had 
>> it running just fine the other day. Any help at all would be most 
>> appreciated.
>>
>>     
>
> You haven't provides a lot of concrete information, like error messages
> during boot or "mdadm -E" output of devices or even kernel/mdadm versions, so
> I can only guess, but my guess would be that you can fix it by assembling
> the array with "--update=homehost"
>
> i.e.
>    mdadm --assemble /dev/mdwhatever  \
>    --update=homehost /dev/device1 /dev/device2 ....
>
>   

My take on hostname is that it causes more users problems than it helps, 
and that it would have been better as an option to the assemble function 
for those who actually need that checking. More people have little RAID 
USB boxes than have some shared storage.

Do *NOT* read this as a suggestion to change, just a comment on it as an 
example of "unintended results."

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

