From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Successful RAID 6 setup
Date: Mon, 09 Nov 2009 12:37:57 -0500
Message-ID: <4AF85375.9@tmr.com>
References: <20091104184049356.ZIDJ2725@cdptpa-omta04.mail.rr.com> 	<4AF5BDF3.8020907@redhat.com> <aebf5d970911072242l3876282fm93dc938dd3df1990@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970911072242l3876282fm93dc938dd3df1990@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Beolach <beolach@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Beolach wrote:
> On Sat, Nov 7, 2009 at 11:35, Doug Ledford <dledford@redhat.com> wrote:
>   
>> On 11/04/2009 01:40 PM, Leslie Rhorer wrote:
>>     
>>>       I would recommend a larger chunk size.  I'm using 256K, and even
>>> 512K or 1024K probably would not be excessive.
>>>       
>> OK, I've got some data that I'm not quite ready to send out yet, but it
>> maps out the relationship between max_sectors_kb (largest request size a
>> disk can process, which varies based upon scsi host adapter in question,
>> but for SATA adapters is capped at and defaults to 512KB max per
>> request) and chunk size for a raid0 array across 4 disks or 5 disks (I
>> could run other array sizes too, and that's part of what I'm waiting on
>> before sending the data out).  The point here being that a raid0 array
>> will show up more of the md/lower layer block device interactions where
>> as raid5/6 would muddy the waters with other stuff.  The results of the
>> tests I ran were pretty conclusive that the sweet spot for chunk size is
>> when chunk size is == max_sectors_kb, and since SATA is the predominant
>> thing today and it defaults to 512K, that gives a 512K chunk as the
>> sweet spot.  Given that the chunk size is generally about optimizing
>> block device operations at the command/queue level, it should transfer
>> directly to raid5/6 as well.
>>
>>     
>
> This only really applies for large sequential io loads, right?  I seem
> to recall
> smaller chunk sizes being more effective for smaller random io loads.
>   

Not true now (if it ever was). The operative limit here is seek time, 
not transfer time. Back in the day of old and slow drives, hanging off 
old and slow connections, the time to transfer the data was somewhat of 
an issue. Current SATA drives and controllers have higher transfer 
rates, and until SSD make seek times smaller bigger is better within reason.

Related question: that said, why is a six drive raid6 slower than a four 
drive? On a small write all the data chunks have to be read, but that 
can be done in parallel, so the limit should stay at the seek time of 
the slowest drive. In practice it behaves as if the data chunks were 
being read one at a time. Is that real, or just fallout from not a long 
enough test to smooth out the data?

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

