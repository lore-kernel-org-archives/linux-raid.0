From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and
 internal bitmap
Date: Thu, 18 Oct 2007 08:43:04 -0400
Message-ID: <471754D8.2060909@tmr.com>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>	 <4716769E.5030508@tmr.com> <170fa0d20710171421l4ff62ebdwdef307e71a2ad30d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20710171421l4ff62ebdwdef307e71a2ad30d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Snitzer wrote:
> On 10/17/07, Bill Davidsen <davidsen@tmr.com> wrote:
>   
>> Mike Snitzer wrote:
>>     
>>> mdadm 2.4.1 through 2.5.6 works. mdadm-2.6's "Improve allocation and
>>> use of space for bitmaps in version1 metadata"
>>> (199171a297a87d7696b6b8c07ee520363f4603c1) would seem like the
>>> offending change.  Using 1.2 metdata works.
>>>
>>> I get the following using the tip of the mdadm git repo or any other
>>> version of mdadm 2.6.x:
>>>
>>> # mdadm --create /dev/md2 --run -l 1 --metadata=1.0 --bitmap=internal
>>> -n 2 /dev/sdf --write-mostly /dev/nbd2
>>> mdadm: /dev/sdf appears to be part of a raid array:
>>>     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
>>> mdadm: /dev/nbd2 appears to be part of a raid array:
>>>     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
>>> mdadm: RUN_ARRAY failed: Input/output error
>>> mdadm: stopped /dev/md2
>>>
>>> kernel log shows:
>>> md2: bitmap initialized from disk: read 22/22 pages, set 715290 bits, status: 0
>>> created bitmap (350 pages) for device md2
>>> md2: failed to create bitmap (-5)
>>> md: pers->run() failed ...
>>> md: md2 stopped.
>>> md: unbind<nbd2>
>>> md: export_rdev(nbd2)
>>> md: unbind<sdf>
>>> md: export_rdev(sdf)
>>> md: md2 stopped.
>>>
>>>       
>> I would start by retrying with an external bitmap, to see if for some
>> reason there isn't room for the bitmap. If that fails, perhaps no bitmap
>> at all would be a useful data point. Was the original metadata the same
>> version? Things moved depending on the exact version, and some
>> --zero-superblock magic might be needed. Hopefully Neil can clarify, I'm
>> just telling you what I suspect is the problem, and maybe a
>> non-destructive solution.
>>     
>
> Creating with an external bitmap works perfectly fine.  As does
> creating without a bitmap.  --zero-superblock hasn't helped.  Metadata
> v1.1 and v1.2 works with an internal bitmap.  I'd like to use v1.0
> with an internal bitmap (using an external bitmap isn't an option for
> me).
>   

Unless there's a substantial benefit from using the 1.0 format, you 
might want to go with something which works. I would suggest using 
--bitmap-chunk, but the man page claims it doesn't apply to internal 
bitmaps. It also claims the bitmap size is chosen automatically to best 
use available space, but "doesn't work" seems an exception to "best 
use." ;-)
> It does appear that the changes to sb super1.c aren't leaving adequate
> room for the bitmap.  Looking at the relevant diff for v1.0 metadata
> the newer super1.c code makes use of a larger bitmap (128K) for
> devices > 200GB.  My blockdevice is 700GB.  So could the larger
> blockdevice possibly explain why others haven't noticed this?
>   
Could be, although I have arrays larger than that and haven't been 
bitten. Then again, none of mine use the 1.0 metadata format as I 
recall. Perhaps Neil will explain his thinking on these formats, I can 
see 1.0 and 1.1, but the 1.2 format uses the 4k offset to no obvious 
benefit. In any case, you have a workable solution, so you can move on 
if time is an issue, or wait for Neil to comment on this. I didn't see 
an obvious problem with the 1.0 code WRT bitmaps, but I looked quickly 
and at a 2.6.3 source I had handy.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

