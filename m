From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Verifying spare drive, best practices
Date: Tue, 25 Mar 2008 12:19:34 -0400
Message-ID: <47E92616.1030007@tmr.com>
References: <47E33AF8.6020106@harddata.com> <18408.33825.920147.425644@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.33825.920147.425644@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday March 20, maurice@harddata.com wrote:
>   
>> Given this situation:
>> 7 disks in total
>> RAID5 of 6 disks, and a hot spare.
>>
>> mdadm show the 6 disks, but not the spare.
>>
>> As a maintenance question, where one wants to periodically ensure that 
>> the hot spare is both available and good.
>> How should one best :
>> 1) Verify the hot spare is still available.
>>     
>
>  - On the relevant line in mdadm.conf, put "spares=1"
>  - have a daily cron job that runs
>      mdadm --montor --scan --oneshot
>
> It will report every day with a "SparesMissing" event if the right
> number of spares is not present.
>   

Another case for raid4e ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


