From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 07 Jun 2013 17:43:46 -0400
Message-ID: <51B25412.5050709@tmr.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com> <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com> <CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com> <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com> <20130607165236.60ac7451@natsu> <CAO9HMNG2M7KDke3A0c06G47kvVWgssu7ur47BN=0goc2ELDhKQ@mail.gmail.com> <51B1DD93.1010904@hardwarefreak.com> <CAO9HMNG0-hhgj1V+8yVe6F_mqsRAiJgZf+06vo-Pt0BUEYjS0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNG0-hhgj1V+8yVe6F_mqsRAiJgZf+06vo-Pt0BUEYjS0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Steve Bergman wrote:
> I've used both CFQ and Deadline for testing. It doesn't make a
> measurable difference for either the multiple dd's or for the
> single-threaded C/ISAM rebuild. (In fact, deadline, while often better
> for servers, can have problems with mixed sequential/random access
> workloads. At least according to what I've seen over on the PostgreSQL
> lists. It's no surprise that deadline doesn't help my single-threaded
> workload. Also note that deadline has shown itself to be slightly
> superior to noop for SSD's in certain benchmarks.) There's no one size
> fits all answer. Until the particular workload is actually tested, it
> *is* guesswork. I/O scheuling is too complicated for it to be
> otherwise.
Can't say one way or the other on SSD, but I can't measure any big benefit of 
deadline on RAID-5 or RAID-10. I haven't done proper testing on RAID-6, so I 
can't say.
> Since this is an unusual RAID10 situation, and I have plenty of spare
> processor available, I'm going to try RAID5 over the weekend. I've
> never used it. But I'm guessing that parity might come at a lower
> bandwidth cost than mirroring. Should be a fun weekend. :-)
When testing RAID-10, but sure you set it up for 'far' copies, since this should 
improve transfer rate, particularly under single thread read.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


