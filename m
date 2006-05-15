From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re[2]: Problem with large devices >2TB
Date: Mon, 15 May 2006 17:41:04 +0400
Message-ID: <591203702.20060515174104@2ka.mipt.ru>
References: <0376848.20060510150440@2ka.mipt.ru>
 <e482qu$dkq$1@terminus.zytor.com>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e482qu$dkq$1@terminus.zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello H.,

Monday, May 15, 2006, 12:10:06 AM, you wrote:

HPA> Followup to:  <0376848.20060510150440@2ka.mipt.ru>
HPA> By author:    Jim Klimov <klimov@2ka.mipt.ru>
HPA> In newsgroup: linux.dev.raid
>> 
>>   Since the new parted worked ok (older one didn't), we were happy
>>   until we tried a reboot. During the device initialization and after
>>   it the system only recognises the 6 or 7 partitions which start
>>   before the 2000Gb limit:
>> 

HPA> For a DOS partition table, there is no such thing as a partition
HPA> starting beyond 2 TB.  You need to use a GPT or other more
HPA> sophisticated partition table.
Thank you for the suggestion, we'll research it. Haven't tried any
other partitioning schemes before :)

A couple of short yes-no questions, if I may:
1) Are the GPT tables a feature of Itanium platforms, or can they be
   used on usual 32-bit (Xeon) servers with Linux inside?
2) Is it possible to convert the partitioning schemes "on-the-fly",
   or should we backup one array, repartition it and format the new
   partitions, and restore the data? I believe this is a safer way
   in any case, but several terabytes are not so easy and quick to
   back up :)

And a longer question:
3) Are there any other features I should know of before relying on
   GPT? Device naming? Addressing? Driver updates? Boot-up issues?

I'll use Google to find more FAQs now... ;)
   
-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

