From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Tue, 19 Dec 2017 10:35:57 +0000
Message-ID: <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
 <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org>
 <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
 <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
 <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
 <CACsGCyS9-K4ZJPKauRZkGFRPd0cvShYLViE87i47=RCY1UkbnQ@mail.gmail.com>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 12/18/2017 4:09 PM, Phil Turmel wrote:
> Hi Alexander,
> 
> On 12/18/2017 10:51 AM, Alexander Shenkin wrote:
>> Hi all,
>>
>> I'm getting back to this now that I'll have time, apologies for the
>> delay.  So, is the following correct in the case of a read error?
> 
> Not quite.
> 
>> 1) System tries to read an unreadable sector
> 
>> 2) Drive timeout reports unreadable based on drive timeout setting.
> 
>> 2a) In this case, mdadm sees the sector is unreadable and rewrites it
>> elsewhere on that drive.
> 
> No.  MD reconstructs the sector from redundancy (mirror or reverse
> parity calc or reverse P+Q syndrome) and writes it back to the *same*
> sector.  Since the drive firmware reported an error here, it knows to
> verify the write as well.  If the verification fails, the drive firmware
> will relocate the sector in the background, invisible to the upper
> layers.  As far as MD is concerned, that sector address is fixed either
> way.  Relocations are handled entirely within the drive.  MD does not
> perform or track relocations.
> 
>> 3) If linux hangcheck timer runs out before the drive timeout, then
>> linux aborts the read, logs an error, and mdadm isn't given a chance
>> to rewrite elsewhere based on checksums.
> 
> No.  The hangcheck timer issue described in your forwarded email is
> unrelated.  And MD doesn't use checksums.
> 
> Each drive has a device driver timeout, as you note below, found at
> /sys/block/*/device/timeout, that linux's ATA/SCSI stack uses to cut off
> non-responsive controller cards and/or drives.  If that timer runs out
> on a read before the drive reports the read error, the low level
> *driver* reports a read error to the MD layer.  MD treats it the same as
> any other read error, locating or recomputing the sector from redundancy
> as above.  The difference in this case is that the physical drive isn't
> talking to the controller (link reset in progress, typically) and the
> corrective rewrite of the sector (to fix or relocate within the drive)
> is refused, and that write error causes MD to kick out the drive.  And
> the pending sector is also left unfixed. >
>> Given all this, it seems to me that I should now set the hangcheck
>> timer to something greater than drive timeout (180 seconds).  Does
>> that sound right?  Otherwise, linux will kill the rewrite again, no?
> 
> In and of itself, waiting on I/O is not a hang.  So it should not be
> applicable.

Ok, so, it's now my understanding that I would normally be ok, having 
set the driver timeout to 180 secs (thus giving time for the seagate 
drive to report the read error back up to the MD layer before 180 secs 
is up).  In my case, however, the kernel hangcheck timer is interrupting 
the process (md?) that is waiting on the sector read at 120 secs. 
Therefore, the writeback doesn't happen.

Thus, I should set the hangcheck to something > 120 (say, 180 secs - 
should it be >180 to let the driver timeout first?).  Does this sound 
correct?  Apologies if I'm repeating info from before - just trying to 
be sure about what I'm doing before I go ahead and do it.

If that's correct, I'll add the following line in /etc/sysctl.conf:

kernel.hung_task_timeout_secs = 180

I'll make sure the setting has taken, and then I'll run:

sudo /usr/share/mdadm/checkarray --idle --all

Thanks,
Allie

