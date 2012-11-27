From: David Brown <david.brown@hesbynett.no>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 14:05:30 +0100
Message-ID: <50B4BA9A.4070504@hesbynett.no>
References: <14319197.21.1353936449959.JavaMail.root@zimbra> <50B48BAA.8060903@hesbynett.no> <50B4934F.6060105@fastmail.fm> <50B4A215.4000203@hesbynett.no> <50B4B2AA.5010809@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4B2AA.5010809@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/11/2012 13:31, Bernd Schubert wrote:
> On 11/27/2012 12:20 PM, David Brown wrote:
>> I can certainly sympathise with you, but I am not sure that data
>> checksumming would help here.  If your hardware raid sends out nonsense,
>> then it is going to be very difficult to get anything trustworthy.  The
>
> When a single hardware unit (any kind of block device) in a
> raid-level > 0 decides to send wrong data, correct data always can be
> reconstructed. You only need to know which unit it is - checksums help
> to figure that out.

If checksums (as described in the paper) only "help" to figure that out, 
then they are not good enough - you can only do automatic on-the-fly 
correction if you are /sure/ you know which device is the problem (at 
least for a very high probability of "sure").  I think that adding an 
extra checksum block to the stripe only gives an indication of the 
problem disk (or lower-level raid) - without being sure of the order 
that data hits the different disks (or lower-level raids), I don't think 
it is reliable enough.  (I could be wrong in all this - I'm just waving 
around ideas, and have no experience with big arrays.)

>
>> obvious answer here is to throw out the broken hardware raid and use a
>> system that works - but it is equally obvious that that is easier said
>> than done!  But I would find it hard to believe that this is a common
>> issue with hardware raid systems - it goes against the whole point of
>> data storage.
>
> With disks it is not that uncommon. But yes, hardware raid controllers
> usually do not scramble data.

With disks it /is/ uncommon.  /Detected/ disk errors are not a problem - 
the disks's own ECC system finds it has an unrecoverable error, and 
returns a read error, and the raid system replaces the data using the 
rest of the stripe.  It is /undetected/ disk errors that are a problem. 
  Typical figures I have seen are around 1 in 1e12 4KB blocks - or 1 in 
3e16 bits.  If you've got a 1 PB disk array, that's one error for every 
four full reads - which is certainly enough to be relevant, but I 
wouldn't say it is "not that uncommon".

>
>>
>> There is always a chance of undetected read errors - the question is if
>> the chances of such read errors, and the consequences of them, justify
>> the costs of extra checking.  And if they /do/ justify extra checking,
>> are data checksums the right way?  I agree with Neil's post that
>> end-to-end checksums (such as CRCs in a gzip file, or GPG integrity
>> checks) are the best check when they are possible, but they are not
>> always possible because they are not transparent.
>
> Everything below block or filesystem level is too late. Just remember,
> writing not a complete stripe implies reads in order to update the p and
> q parity blocks. So even if your application could later on detect that
> (Do your applications usually verify checksums?  In HPC I don't know of
> a single application to do that...), file system meta data already would
> be broken.
>

When you say "below block or filesystem level", I presume you mean such 
as "application level"?  I always think of that as above the filesystem, 
which is above the block level.  I certainly agree that it is often not 
practical to verify checksums at the application level.

As I mentioned in another post, I think there are times when filesystem 
checksumming can make sense.  I also described another idea at block 
level - I am curious as to what you think of that.

mvh.,

David


