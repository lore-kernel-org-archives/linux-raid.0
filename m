From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Sun, 31 Jan 2010 08:08:05 -0600
Message-ID: <4B658EC5.9020004@gmail.com>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org> <4B64B0C1.1040503@texsoft.it> <4B64DB75.70607@gmail.com> <4B655F63.2000705@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B655F63.2000705@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giovanni Tessore wrote:
> 
>> I have never seen a properly good disk that gets that high of error 
>> rate actually exposed to the OS.  I have dealt with >5000 disk for 
>> several years of history on the 5000+ disks.
> I have experience with not so many disks, but I was used that they are 
> quite reliable, and that the first read error reported to OS is symptom 
> of an incominc failure; I always replaced them in such case, and this is 
> why I am so amazed that kernel 2.6.15 changed the way it manages read 
> errors (as also Asdo said, it's ok for raid-6, but unsafe for raid-5, 1, 
> 4, 10).

Good disks to rescan, and replace the bad blocks before you see them, 
if you help the disks by doing your own scan then things are better.

> 
> Actually I had not a single read error since 2-3 years on my systems, 
> but now ... in a week, I had 4 disk failed (yes... another one since I 
> started this thread!!) ... it's 30% of the total disks in my systems ... 
> so I'm really puzzled out ... I don't know what to trust ... I'm just in 
> the hands of God

That tells me you have one of those "bad" lots.  If the disks start 
failing in mass in <3-4 years it is usually a bad lot.  You can 
manually scan (read) the whole disk, and if the sectors take weeks to 
go bad then the normal disk reallocation will prevent errors (if you 
are scanning faster than they go fully bad--the disk will replace when 
the error rate is high, but not so high that the disk can internally 
reconstruct the data).   The more often that you scan, the higher rate 
of sectors going bad can be corrected.

The reason that md rewrites and does not knock out the read errors, is 
when you get a read error you do not know if you can read the other 
disks.   Consider that if you have 5 crappy disks that have say 1000 
read errors per disk, the chance of one of the other of disks having 
the same sector bad is fairly small.  But given that one disk has a 
read error, the odds of another disk also having a read error is alot 
more likely, especially if none of the other disks have been read in 
several months.

What kind of disks are they?   And were you doing checks on the arrays 
and if so how often?  If you never do checks then a sector won't get 
check and moved before it goes fully bad, and can have months of not 
being read to go completely bad.

>> Nothing in the error rate indicated that behavior, so if you get a bad 
>> lot it will be very bad, if you don't get a bad lot you very likely 
>> won't have issues.   Now including the bad lots data into the overall 
>> error rate, may result in the error rate being that high, but you luck 
>> will depend on if you have a good or bad lot.
> My disks are form same manufacturer as size, but different lot, as 
> bought in different times, and different models.
> Systems are well protected by UPS and in different places!
> ... my unluky week .. or I have a big EM storm over here...
> I've recall to duty old 120G disks to save some data.

The same manufacturer process usually extends over different sizes 
(same underlying platter density), and over several months.   The last 
time I saw the issue 160gb, and 250 gb enterprise and non-enterprise 
disks will all affected.   The symptom was that the sectors went bad 
really really fast, I would suspect that there was a process issues 
with either the design, manufacturer, or quality control of the 
platter that resulting in the platters going bad at a much higher rate 
than expected.
