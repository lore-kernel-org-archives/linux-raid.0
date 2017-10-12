From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 12 Oct 2017 10:50:29 +0100
Message-ID: <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/11/2017 6:10 PM, Phil Turmel wrote:
> On 10/11/2017 06:31 AM, Alexander Shenkin wrote:
>> On 10/10/2017 1:55 PM, Phil Turmel wrote:
> 
>>> Which means the pending sector found by a smartctl background scan is
>>> likely in a non-array data area.  And if not, the next scrub will fix
>>> it.  You can run checkarray yourself if you don't want to wait.
>>
>> Thanks Phil.  I ran checkarray --all --idle, and it completed fine, with
>> no Rebuild messages as far as I could see (looked in dmesg &
>> /var/log/syslog, see below).
>>
>> [4444093.042246] md: data-check of RAID array md0
>> [4444093.042252] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> [4444093.042254] md: using maximum available idle IO bandwidth (but not
>> more than 200000 KB/sec) for data-check.
>> [4444093.042262] md: using 128k window, over a total of 1950656k.
>> [4444093.192032] md: delaying data-check of md2 until md0 has finished
>> (they share one or more physical units)
>> [4444106.854418] md: md0: data-check done.
>> [4444106.863292] md: data-check of RAID array md2
>> [4444106.863295] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> [4444106.863298] md: using maximum available idle IO bandwidth (but not
>> more than 200000 KB/sec) for data-check.
>> [4444106.863304] md: using 128k window, over a total of 2920188928k.
>> [4475376.852520] md: md2: data-check done.
>>
>> SMART still shows those 8 unreadable sectors.  dmesg has a bunch of
>> related errors, copied below.
> 
> Uh-oh.  Your kernel has a hangcheck timer that is shorter (120 seconds)
> than the URE timeout of your crappy Seagate drive (w/ driver times out
> at 180 seconds).  So the writeback that would fix the URE isn't happening.
> 
> You'll need to set your hangcheck timer to 180 seconds, too.  I'm not
> sure how to do that.  (I've never seen this particular combination, but
> it would be another black mark on desktop drives in raid arrays.)

Thanks Phil... Googling around, I haven't found a way to change it 
either, but then again, I'm not really sure what to search for.

What about changing my default disk timeout to something less than 120 
secs?  Say, 100 secs instead of 180?

Seems like this issue should probably make it into the timeout wiki 
page, no?  Perhaps some instructions on how to query your system's 
hangcheck timeout, and thus making sure that you set your drive timeouts 
to less than that?

Thanks,
Allie
