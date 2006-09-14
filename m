From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: PROBLEM: system crash on AMD64 with 2.6.17.11 while accessing
 3TB Software-RAID5
Date: Thu, 14 Sep 2006 18:37:27 -0400
Message-ID: <4509D9A7.8060107@tmr.com>
References: <758194931.20060829001041@TU-Ilmenau.de> <17654.24059.852752.251958@cse.unsw.edu.au> <44F6E962.40900@TU-Ilmenau.de> <44FC5D1A.6020809@tmr.com> <4500CF39.8010806@tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4500CF39.8010806@tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ralf Herrmann <ralf.herrmann@tu-ilmenau.de>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ralf Herrmann wrote:

> Dear Mr. Davidson and Mr. Brown,
>
>> It certainly is a legitimate question, and marginal power would have 
>> been at the end of my list as well... However, if all else fails, try 
>> formatting the new drives to use only the size of the old drive 
>> capacity (RAID on small partitions) and see if that works. If so you 
>> may have found some rare size-related bug.
>
>
> Seems as if the new power supply did the trick. The box's been
> running smoothly, for about 2 days lately.
> I'm currently not in office, but since i didn't get emergency
> calls from my colleagues i assume it still works.
>
> Thanks again for your time, 


Thanks for letting us know what it was. Even if it was not the first 
thing we suggested. ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

