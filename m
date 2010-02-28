From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Sat, 27 Feb 2010 19:01:20 -0500
Message-ID: <4B89B250.1060707@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>	 <6db64f7872286165ac1fd3436e9d6476@localhost>	 <20100218100547.7aecdc34@notabene.brown>	 <20100219151809.GB4995@lazy.lzy>	 <20100220090208.06c1130f@notabene.brown> <4B853D99.1040902@tmr.com>	 <20100225083748.42f024aa@notabene.brown> <4B8833BA.4010503@tmr.com>	 <20100227080938.6540f041@notabene.brown>	 <4B884930.1070205@shiftmail.org> <4877c76c1002262201h31051c44r9d756e4969a71fbb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1002262201h31051c44r9d756e4969a71fbb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Asdo <asdo@shiftmail.org>, Neil Brown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans wrote:
> On Fri, Feb 26, 2010 at 2:20 PM, Asdo <asdo@shiftmail.org> wrote:
>   
>> Neil Brown wrote:
>>     
>>> Actually, I'm no longer convinced that the checksumming idea would work.
>>> If a mem-mapped page were written, that the app is updating every
>>> millisecond (i.e. less than the write latency), then every time a write
>>> completed the checksum would be different so we would have to reschedule
>>> the
>>> write, which would not be the correct behaviour at all.
>>> So I think that the only way to address this in the md layer is to copy
>>> the data and write the copy.  There is already code to copy the data for
>>> write-behind that could possible be leveraged to do a copy always.
>>>
>>>       
>> The concerns of slowdowns with copy could be addressed by making the copy a
>> runtime choice triggered by a sysctl interface, a file in /sys/block/mdX/md/
>> interface where one can echo "1" to enable copies for this type of raid. Or
>> better 1 could be the default (slower but safer, or if not safer, at least
>> to avoid needless questions on mismatches on this ML by new users, and to
>> allow detection of REAL mismatches which can be due to cabling or defective
>> disks) and echoing 0 would increase performances at the cost of seeing lots
>> of false positive mismatches.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
> Isn't there some way of making the page copy-on-write using hardware
> and/or an in-kernel structure?  Ideally copying could be avoided
> /unless/ there is change.  That way each operation looks like an
> atomic commit.
>   

As I think about this, one idea was to add a write-in-progress flag, so 
that the filesystem, or library, or whatever would know not to change 
the page. That would mean that every filesystem would need to be 
enhanced, or that the "safe write" would be optional on a per-filesystem 
level. Implementation of O_DIRECT could do it, or not, and there could 
be a safe way to write.

However, it occurs to me that there are several other levels involved, 
and so it could be better but not perfect. While md could flag the start 
and finish of write, you then need to have the next level, the device 
driver, do the same thing, so md knows when the data need not be frozen. 
"But wait, there's more," as they say, the device driver need to track 
when the data are transferred to the actual device, and the device needs 
to report when the data actually hit the platter, or you could still 
have possible mismatches.

All of that reminds us of the discussion of barriers, and flush cache 
commands, and other performance impacting practices. So in the long run 
I think the most effective solution, one which has the highest 
improvement at the lowest cost in performance, is a copy. Now if Neil 
liked my idea of doing a checksum before and after a write, and a copy 
only in the cases where the data had changed, the impact could be pretty 
small.

All that depends on two things, Neil thinking the whole thing is worth 
doing, and no one finding a flaw in my proposal to do a checksum rather 
than a copy each time.

And to return to your original question, no. Hardware COW works on 
memory pages, a buffer could span pages and a write to a page might not 
be in the part of the page used for the i/o buffer. So as nice as that 
would be, I don't think the hardware supports it. And even if you could, 
the COW needs to be done in the layer which tries to change the buffer, 
so md would set COW and the filesystem would have to deal with it. I am 
pretty sure that's a layering violation, big time. The advisory "write 
in progress" flag might be acceptable, it's information the f/s can use 
or not.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

