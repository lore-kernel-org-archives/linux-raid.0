From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Fri, 26 Feb 2010 17:15:27 -0500
Message-ID: <4B8847FF.8080609@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>	<4B67451F.8040206@tmr.com>	<20100202093738.44b4fece@notabene.brown>	<4B684087.50001@tmr.com>	<20100211161444.7a0ea7bb@notabene.brown>	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>	<4B7B0D45.7040801@tmr.com>	<6db64f7872286165ac1fd3436e9d6476@localhost>	<20100218100547.7aecdc34@notabene.brown>	<20100219151809.GB4995@lazy.lzy>	<20100220090208.06c1130f@notabene.brown>	<4B853D99.1040902@tmr.com>	<20100225083748.42f024aa@notabene.brown>	<4B8833BA.4010503@tmr.com> <20100227080938.6540f041@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100227080938.6540f041@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Fri, 26 Feb 2010 15:48:58 -0500
> Bill Davidsen <davidsen@tmr.com> wrote:
>
>   
>>> The idea of calculating a checksum before and after certainly has some merit,
>>> if we could choose a checksum algorithm which was sufficiently strong and
>>> sufficiently fast, though in many cases a large part of the cost would just be
>>> bringing the page contents into cache - twice.
>>>
>>> It has the advantage over copying the page of not needing to allocate extra
>>> memory.
>>>
>>> If someone wanted to try an prototype this and see how it goes, I'd be happy
>>> to advise....
>>>     
>>>       
>> Disagree if you wish, but MD5 should be fine for this. While it is not 
>> cryptographically strong on files, where the size can be changed and 
>> evil doers can calculate values to add at the end of the data, it should 
>> be adequate on data of unchanging size. It's cheap, fast, and readily 
>> available.
>>
>>     
>
> Actually, I'm no longer convinced that the checksumming idea would work.
> If a mem-mapped page were written, that the app is updating every
> millisecond (i.e. less than the write latency), then every time a write
> completed the checksum would be different so we would have to reschedule the
> write, which would not be the correct behaviour at all.
> So I think that the only way to address this in the md layer is to copy
> the data and write the copy.  There is already code to copy the data for
> write-behind that could possible be leveraged to do a copy always.
>
>   
Your point is valid about the possibility, but consider this, if the 
checksum fails, then at that point do the copy and write again.
> Or I could just stop setting mismatch_cnt for raid1 and raid10.  That would
> also fix the problem :-)
>
>   
s/fix/hide/  ;-)

My feeling is that we have many ways to change the data, O_DIRECT, aio, 
threads, mmap, and probably some I haven't found yet. Rather than think 
that you could prevent that without a flaming layer violation, perhaps 
my thought above, to detect the fact that the data has changed, and at 
that point do a copy and write unchanging data to all drives. How that 
plays with O_DIRECT I can't say, but it sounds to me as if it should 
eliminate the mismatches without a huge performance impact. Let me know 
if this addresses your concern with writing forever without taking much 
overhead.

The question is why this happens with raid-1 and doesn't seem to with 
raid-[56]. And I don't see mismatches on my raid-10, although I'm pretty 
sure that neither mmap or O_DIRECT is used on those arrays.

What would seem to be optimal is some COW on the buffer to prevent the 
buffer from being modified while it's being used for actual i/o. Doesn't 
seem hardware supports it, page size, buffer size and sector size all vary.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

