From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Sat, 30 Jan 2010 19:23:01 -0600
Message-ID: <4B64DB75.70607@gmail.com>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org> <4B64B0C1.1040503@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B64B0C1.1040503@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: Asdo <asdo@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giovanni Tessore wrote:
> 
>> RAID-5 unfortunately is inherently insecure, here is why:
>> If one drive gets kicked, MD starts recovering to a spare.
>> At that point any single read error during the regeneration (that's a 
>> scrub) will fail the array.
>> This is a problem that cannot be overcome in theory.
> Yes, I was just getting the same conclusion :-(
> Suppose you have 2Tb mainstream disks, with a read error ratio of 1 
> sector each 1E+14 bits = 1.25E+13 bytes.
> It means that you likely get an error every 6.25 times you read the 
> whole disk!
> So in case of failure of a disk, you have 1 possibility over 6 to fail 
> the array during recostruction.
> Simply unacceptable!
> 
> I looked at specs of some enterprise disks, and the read error ratio for 
> them is 1 sector each 1E+15 or each 1E+16. Better but still risky.
> Ok.. I'll definitely move to raid-6.
> 
> Also raid-1 with less than 3 disks becomes useless the same way :-(
> Idem for raid-10 ...wow
> 
> Well, these two threads on read errors came out as kinda instructive ... 
> doh!!
> 
> Regards
> 

The manufacturer error numbers don't mean much, typically good disks 
won't fail a rebuild that often, I have done alot of rebuilds and read 
  errors during a rebuild are fairly rare, especially if you are doing 
proper patrol reads/scans of the raid arrays, if you have disks 
setting for long periods of time without read scans, then all bets are 
off and you will have issues.

I have never seen a properly good disk that gets that high of error 
rate actually exposed to the OS.  I have dealt with >5000 disk for 
several years of history on the 5000+ disks.

I have seen a few manufacturer "lots" of disks that had seriously high 
error rates (certain sizes and certain manufacture ranges), in one set 
of disks (2000 desktop drives, and 600 "enterprise" drives) the 
desktop drives were almost perfect (same company as the "enterprise" 
disks, <10 replaced after 2 years, out of the 600 "enterprise" disks 
we had replaced about 50 (read errors) when we finally got the 
manufacture send a engineer on-site to validate what was happening and 
RMA the entire lot (all 550 disk that had not yet been replaced).

Nothing in the error rate indicated that behavior, so if you get a bad 
lot it will be very bad, if you don't get a bad lot you very likely 
won't have issues.   Now including the bad lots data into the overall 
error rate, may result in the error rate being that high, but you luck 
will depend on if you have a good or bad lot.
