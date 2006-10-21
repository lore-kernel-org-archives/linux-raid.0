From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Propose of enhancement of raid1 driver
Date: Sat, 21 Oct 2006 18:01:05 +0200
Message-ID: <453A4441.1040409@wpkg.org>
References: <45347D6E.3000600@mieszczak.com.pl> <17718.61672.794099.425723@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17718.61672.794099.425723@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Miroslaw Mieszczak <mirek@mieszczak.com.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 17, mirek@mieszczak.com.pl wrote:
>> I would like to propose an enhancement of raid 1 driver in linux kernel.
>> The enhancement would be speedup of data reading on mirrored partitions.
>> The idea is easy.
>> If we have mirrored partition over 2 disks, and these disk are in sync, there is
>> possibility of simultaneous reading of the data from both disks on the same way
>> as in raid 0. So it would be chunk1 read from master, chunk2 read from slave at
>> the same time. 
>> As result it would give significant speedup of read operation (comparable with
>> speed of raid 0 disks).
> 
> This is not as easy as it sounds.
> Skipping over blocks within a track is no faster than reading blocks
> in the track, so you would need to make sure that your chunk size is
> larger than one track - probably it would need to be several tracks.

What you said is certainly true when we read one file at a given moment.

What if we read two different files at a given time? Certainly, it would 
be faster if DRIVE_1 reads FILE_1, and DRIVE_2 reads FILE_2.


> Raid1 already does some read-balancing, though it is possible (even
> likely) that it doesn't balance very effectively.  Working out how
> best to do the balancing in general in a non-trivial task, but would
> be worth spending time on.

Probably what I said before isn't very correct, as RAID-1 has no idea of 
the filesystem that is on top of it; rather, it will see attempts to 
access differend areas of the array?



-- 
Tomasz Chmielewski
http://wpkg.org

