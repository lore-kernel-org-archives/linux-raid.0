From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sun, 01 Apr 2012 09:06:39 +0100
Message-ID: <4F780C8F.8060105@anonymous.org.uk>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com> <4F77DF1F.6080103@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F77DF1F.6080103@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: daobang wang <wangdb1981@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/04/2012 05:52, Stan Hoeppner wrote:
[...]
>> 5. The real application is 200 D1(2Mb/s) video streams write 500MB
>> files on the XFS.
>
> This is a 50 MB/s raw stream rate with 200 writers to 200 target files.
>   It is very likely that neither 8 nor 16 disks in RAID5 will be able to
> sync this rate due to excessive head seeking, as I previously mentioned.

Handwaving slightly here, but I wonder whether using a lot of write 
cache will help aggregate writes here, since it's not actually random 
writes. If I were to model it as 250MB written every 5 seconds from 200 
writers, that might be able to be persuaded into 40 writes per second, 
which shouldn't cause excessive head seeking. It would be helpful if 
there were also enough additional cache that the reads for any RAID5 
read-modify-write cycles mostly came from cache and didn't need seeks. 
It should be possible to set this up such that, in the event of a crash 
or hardware failure, the filesystem and files are consistent, though 
obviously the last 5 seconds of each file is likely to be lost.

Having said that, even if it can be persuaded to work, I agree that it's 
still the wrong way to go; RAID10 or indeed RAID1+linear look like much 
better solutions.

Cheers,

John.

