From: Brad Campbell <brad@wasp.net.au>
Subject: Re: "Rebuild" speed on a forced resync
Date: Fri, 14 Jan 2005 22:34:02 +0400
Message-ID: <41E8109A.7000603@wasp.net.au>
References: <41E3A0B5.209@wasp.net.au> <16868.28778.598528.338592@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16868.28778.598528.338592@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday January 11, brad@wasp.net.au wrote:
> 
>>G'day all,
>>
>>Just started my big raid using mdadm --update resync to ensure the parity blocks are A-OK after a 
>>kernel panic, and I have been monitoring my Disk IO with
>>iostat -k 5
>>
>>Now this is an average for a 5 second period.
>>I note I'm seeing about 12,456 Kilobytes/sec from each drive, but a cat /proc mdstat is giving me 
>>6716 Kilobytes/sec. Given I'm doing a read consistency check I would expect an mdstat speed 9/10ths 
>>of my bulk per-drive read speed. (This array is sda -> sdj)
>>Am I missing something really obvious?

>>
>>avg-cpu:  %user   %nice    %sys %iowait   %idle
>>           39.18    0.00   60.82    0.00    0.00
>>
>>Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>>hda               0.00         0.00         0.00          0          0
>>sda              97.76     12465.67         0.00      33408          0
>>sdb              97.76     12465.67         0.00      33408          0
>>sdc              97.76     12465.67         0.00      33408          0
> 
> 
> So this is a 5 second sample...
> In 5 seconds, 33408 kB were read.
> That's 6681.6 kB/sec according to my calculator.
> 
> So it looks like iostat is reporting something wrongly.  I would look
> there first.

Ok, fair call on those stats. Having said that, we are talking 6.6 MB/sec per disk. Do I take it the 
/proc/mdstat figure of 6 MB/sec is not a total array rebuild speed, but a speed per array member?

Regards,
Brad
