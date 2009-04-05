From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: RAID halting
Date: Sat, 04 Apr 2009 19:57:50 -0500
Message-ID: <49D8020E.3010705@gmail.com>
References: <20090405000728.GGPW19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405000728.GGPW19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Lelsie Rhorer wrote:
>> If one of your disks was clearing bad sectors then things get messy
>> and when it hits one of these bad sectors that it can successfully
>> move you would get a delay almost every time.
> 
> Yes, but in that case two things would be true:
> 
> 1.  Any write of any sort could readily trigger an event.  The system quite
> regularly writes more than 5000 sectors / second, but never do any of these
> writes trigger an event except in the case where it is a file creation.
> Like I said, the drives have no idea whether the sector they are attempting
> to write is a new file or not, or part of a directory structure or not.

Writes don't trigger this sort of events, it is only the reads, and 
are you sure the data the you wrote is still readable?

> 
> 2.  The kernel would be reporting SMART errors.  It isn't.

Smart had never really worked as good as the disk makers claim.   I 
have tested smart on sets of >1000 drives, and  smarts accuracy for 
detecting bad sector issues with disks was almost useless, I had 50 
known bad drives in the set, smart flagged only 15 of them as bad, and 
on top of that smart flagged another 15-20 drives as bad that did not 
appear to fail at all after months of usage since smart had declared 
them bad.   Basically smart is useful, but it cannot really be 
trusted, if you don't believe me, see google's similar study on large 
numbers of drives.

> 
> Finally, as you said yourself, the situation would result in a delay almost
> every time, yet there are signifcant stretches of time when every single
> file creation works just fine.  Also, it doesn't take a drive 40 seconds,
> let alone 2 minutes, to mark a sector bad.  The array chassis I had
> previously had some sort of problem which made the drives think there were
> bad sectors, when there weren't.  It cause one drive to be marked with more
> than a million bad sectors.  It never paused like this, however.
>

And what I said if you read it carefully is, that *WHEN* you hit a bad 
sector it will cause a delay almost every time, not you will hit a 
delay every time you read the disk.

It will only result in a delay if you hit the magic bad sector.   And 
on reads it cannot mark the sector bad until it successfully reads the 
sector so it tries really hard and takes a long time trying, and once 
it reads that sector successfully it will rewrite it elsewhere and 
mark the sector bad.    When you hit the next bad sector the same 
thing will happen again.   How bad of issue that you have depends on 
if the number of bad sectors on the disk is growing...if you only have 
20 bad ones eventually they will all get reread (maybe) and relocated, 
if you have a few more showing up each day, things will never get any 
better.

When the array chassis had its issue, likely the chassis decided they 
were bad after getting a successful read, the read came back quickly 
and the chassis decided it was bad and marked it as such, the *DRIVE* 
has to think the sector is bad to get the delay, and in the array 
chassis case the drive knew the sector was just find and the array 
chassis misinterpreted what the drive was telling it and decided it 
was bad.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

