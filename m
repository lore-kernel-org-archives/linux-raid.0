From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: way too high reconstruction speed - bug?
Date: Fri, 11 Aug 2006 13:47:20 +0200
Message-ID: <44DC6E48.7070506@wpkg.org>
References: <44DB00E9.8020000@wpkg.org> <44DB7E39.4060001@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44DB7E39.4060001@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Tomasz Chmielewski wrote:
>> [42949428.590000] md: md11: raid array is not clean -- starting 
>> background reconstruction
>> [42949428.620000] raid10: raid set md11 active with 4 out of 4 devices
>> [42949428.630000] md: syncing RAID array md11
>> [42949428.630000] md: minimum _guaranteed_ reconstruction speed: 1000 
>> KB/sec/disc.
>> [42949428.640000] md: using maximum available idle IO bandwidth (but 
>> not more than 200000 KB/sec) for reconstruction.
>> [42949428.650000] md: using 128k window, over a total of 779264640 
>> blocks.
>> [42949428.650000] md: resuming recovery of md11 from checkpoint.
> 
> The recovery was resumed from a previous checkpoint. I guess you 
> rebooted or stopped the array during recovery?
> 
> At any rate, md doesn't calculate resync speed correctly for 
> checkpointed or bitmapped resyncs (it assumes that the skipped portion 
> was actually resynced).
> 
> Neil fairly recently sent in patches to fix this, but I think they won't 
> be in mainline until 2.6.18 or so.

All right, thanks for explanation.

After yet another reboot I had something like speed=7588238K/sec, I can
only wonder when hard drives will have this speed :)


-- 
Tomasz Chmielewski
http://wpkg.org

