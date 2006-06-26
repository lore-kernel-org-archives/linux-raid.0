From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Mon, 26 Jun 2006 10:03:58 -0400
Message-ID: <449FE94E.9000307@tmr.com>
References: <449AEB7C.6040108@cjx.com>	<op.tblclqd3cigqcu@apollo13>	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>	<449BE381.6070000@cjx.com>	<fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>	<68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>	<449C0505.8000601@tmr.com>	<fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com> <17564.52087.651968.635043@cse.unsw.edu.au> <449CF0D0.9080006@comcast.net> <449F22D7.2090604@tmr.com> <449F2D80.6080100@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449F2D80.6080100@comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>
Cc: Neil Brown <neilb@suse.de>, Francois Barre <francois.barre@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Adam Talbot wrote:

>Not exactly sure how to tune for stripe size. 
>What would you advise?
>-Adam
>  
>

See the -R option of mke2fs. I don't have a number for the performance 
impact of this, but I bet someone else on the list will. Depending on 
what posts you read, reports range from "measurable" to "significant," 
without quantifying.

Note, next month I will set up either a 2x750 RAID-1 or 4x250 RAID-5 
array, and if I got RAID-5 I will have the chance to run some metrics 
before putting the hardware into production service. I'll report on the 
-R option if I have any data.

>
>Bill Davidsen wrote:
>  
>
>>winspeareAdam Talbot wrote:
>>
>>    
>>
>>>OK, this topic I relay need to get in on.
>>>I have spent the last few week bench marking my new 1.2TB, 6 disk, RAID6
>>>array. I wanted real numbers, not "This FS is faster because..." I have
>>>moved over 100TB of data on my new array running the bench mark
>>>testing.  I have yet to have any major problems with ReiserFS, EXT2/3,
>>>JFS, or XFS.  I have done extensive testing on all, including just
>>>trying to break the file system with billions of 1k files, or a 1TB
>>>file. Was able to cause some problems with EXT3 and RiserFS with the 1KB
>>>and 1TB tests, respectively. but both were fixed with a fsck. My basic
>>>test is to move all data from my old server to my new server
>>>(whitequeen2) and clock the transfer time.  Whitequeen2 has very little
>>>storage.  The NAS's 1.2TB of storage is attached via iSCSI and a cross
>>>over cable to the back of whitequeen2.  The data is 100GB of user's
>>>files(1KB~2MB), 50GB of MP3's (1MB~5MB) and the rest is movies and
>>>system backups 600MB~2GB.  Here is a copy of my current data sheet,
>>>including specs on the servers and copy times, my numbers are not
>>>perfect, but they should give you a clue about speeds...  XFS wins.
>>> 
>>>
>>>      
>>>
>>In many (most?) cases I'm a lot more concerned about filesystem
>>stability than performance. That is, I want the fastest <reliable>
>>filesystem. With ext2 and ext3 I've run multiple multi-TB machines
>>spread over four time zones, and not had a f/s problem updating ~1TB/day.
>>
>>    
>>
>>Did you tune the extN filesystems to the stripe size of the raid?
>>
>>    
>>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

