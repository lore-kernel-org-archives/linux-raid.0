From: David Brown <david.brown@hesbynett.no>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 13:37:31 +0100
Message-ID: <50B4B40B.3000807@hesbynett.no>
References: <22100889.14.1354016374529.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22100889.14.1354016374529.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

On 27/11/2012 12:39, Roy Sigurd Karlsbakk wrote:
>> I can certainly sympathise with you, but I am not sure that data
>> checksumming would help here. If your hardware raid sends out
>> nonsense, then it is going to be very difficult to get anything
>> trustworthy. The obvious answer here is to throw out the broken
>> hardware raid and use a system that works - but it is equally
>> obvious that that is easier said than done! But I would find it
>> hard to believe that this is a common issue with hardware raid
>> systems - it goes against the whole point of data storage.
>>
>> There is always a chance of undetected read errors - the question
>> is if the chances of such read errors, and the consequences of
>> them, justify the costs of extra checking. And if they /do/ justify
>> extra checking, are data checksums the right way?
>
> The chance of a silent corruption is rather small with your average
> 3TB home storage. On the other hand, if you had a petabyte or five,
> the chances would be very high indeed to get silent corruption (ref
> the CERN study done in 2007). In my last job, I worked with ZFS with
> ~350TiB storage, and there we saw errors happen rather frequently,
> but then, since ZFS checksums data and uses it to deal with errors,
> we never saw any data loss. That is, except on an older machine,
> running ZFS on a hardware RAID controlled storage unit (NexSAN
> SATABeast). We had error corruption on that one as well, after a disk
> failure, and had to resort to restoring from tape, since ZFS couldn't
> control the RAID.

Of course even a small chance-per-bit turns into a significant total 
chance when you have enough bits!  There is always a chance of 
undetected issues - your aim it to reduce that chance until it is no 
longer relevant (or until the chance is under 1 in 150 million per year 
- then you should worry more about being killed by lightning).

>
>> I agree with Neil's post that end-to-end checksums (such as CRCs in
>> a gzip file, or GPG integrity checks) are the best check when they
>> are possible, but they are not always possible because they are not
>> transparent.
>
> The problem with end-to-end-checksums at the application level, is it
> will only be able to detect the error, not fix it, similar to the
> issues I mentioned above.
>

Checksumming, as suggested by the originally mentioned paper, will not 
be able to correct anything either.  At first glance, it might seem that 
it would tell you which block was wrong, and therefore let you re-build 
that block from the rest of the raid stripe.  But that will not be the 
case if there are issues while writing, such as unexpected power 
failures - it could just as easily be the data blocks that are correctly 
written while the checksum block is wrong.  And exactly as discussed in 
Neil's post on "smart" recovery, the principle of least surprise 
suggests giving the data blocks back unchanged is the least harmful.

To do checksumming (and in particular, recovery), requires higher level 
knowledge of the data.  The filesystem can track when it writes a file, 
and update metadata (including, if desired, a data checksum) once it 
knows the file is correctly stored.  But I don't think it can sensibly 
be done at the block device level - the recovery procedure doesn't know 
what is old data, what is new data, or which bit is important to the 
filesystem.

So I think it can make sense to use a filesystem like ZFS or BTRFS that 
can do checksumming - that is a reasonable level to add the checksum.


One way to handle this at md block level would be to have an option for 
raid arrays to always do a full stripe read and consistency check 
whenever a block is read.  If the consistency check fails (without any 
errors being indicated from the drives), the array should simply return 
a read error - it should /not/ attempt to recover the data (since it 
can't tell which parts are the real problem).  If arrays with this 
option are used as first-level arrays, with a "normal" md raid array 
(raid1, raid5, etc.) on top, then the normal raid recovery process will 
replace the bad data and initiate a new write to correct the undetected 
read error.  I think this would perhaps give you the level of 
reliability you are looking for, and be suitable for big arrays (indeed, 
it would be unsuitable for small arrays as you need at least two levels).

mvh.,

David


