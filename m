From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 24 Feb 2010 09:54:17 -0500
Message-ID: <4B853D99.1040902@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>	<4B67451F.8040206@tmr.com>	<20100202093738.44b4fece@notabene.brown>	<4B684087.50001@tmr.com>	<20100211161444.7a0ea7bb@notabene.brown>	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>	<4B7B0D45.7040801@tmr.com>	<6db64f7872286165ac1fd3436e9d6476@localhost>	<20100218100547.7aecdc34@notabene.brown>	<20100219151809.GB4995@lazy.lzy> <20100220090208.06c1130f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100220090208.06c1130f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> md is not in a position to lock the page - there is simply no way it can stop
> the filesystem from changing it.
> The only thing it could do would be to make a copy, then write the copy out.
> This would incur a performance cost.
>
>   
Two thoughts on that - one is that for critical data, give me the option 
at array start time, make the copy, slow the performance and make it 
more consistent. My second thought is that a checksum of the page before 
initiating write and after all writes are complete might be less of a 
performance hit, and still could detect that the buffer had changed.
>> It seems to me, maybe I'm wrong, not a so safe design.
>>     
>
> I think you are wrong.
>
>   
> This is correct.  However it would be equally correct if you were talking
> about s normal disk drive rather than a RAID1 pair.
> If the filesystem changes the page (or allows it to change) while a write is
> pending, then it cannot know what actual data was written.  So it must write
> the block out again before it ever reads it in.
> RAID1 is no different to any other device in this respect.
>
>
>   
>> In other words, would it be better, for the md layer,
>> to be robust against these kind of threats?
>>
>>     
>
> Possibly, but at what cost?
> There are two ways that I can imagine to 'solve' this issue.
>
> 1/ always copy the page before writing.  This would incur a significant
>   overhead, both in the complexity of pre-allocation memory and in the
>   delay taken to perform the copy.  And it would very rarely be actually
>   needed.
> 2/ Have the filesystem protect the page from changes while it is being
>    written.  This is quite possible for the filesystem to do (while it
>    is impossible for md to do).  There could be some performance
>    cost with memory-mapped pages as they would need to be unmapped,
>    but there would be no significant cost for reads, writes, and filesystem
>    metadata operations.
>   

Your next section somewhat mirrors my thought on md checking the data 
after write to be sure it didn't change.

>    Further, any filesystem that wants to make use of the integrity checks
>    that newer drives provide (where the filesystem provides a 'checksum' for
>    the block which gets passed all the way down and written to storage, and
>    returned on a read) will need to do this anyway.  So it is likely the in
>    the near future all significant filesystems will provide all the
>    guarantees md needs or order to simply do nothing different.
>
> So my feeling is that md is doing the best thing already.
>
> I believe 'swap' will always be an issue as unmapping swap pages during write
> could be a serious performance cost.  It might be that the best thing to do
> with swap is to somehow mark the area of an array used for swap as "don't
> care" so md never bothers to resync it, and never reports inconsistencies
> there, as they really are not an issue.
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

