From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 08:54:20 -0500
Message-ID: <50B4C60C.6010409@gmail.com>
References: <14319197.21.1353936449959.JavaMail.root@zimbra> <50B48BAA.8060903@hesbynett.no> <50B4934F.6060105@fastmail.fm> <50B4A215.4000203@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4A215.4000203@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/27/2012 06:20 AM, David Brown wrote:
> On 27/11/2012 11:17, Bernd Schubert wrote:

[...]

>> I will sent patches to better handle parity mismatches during the next
>> weeks (for performance reasons only for background checks).
>>
>> Cheers,
>> Bernd

Give me a heads up when they are ready, and I can get some testing in 
for you.

>>
>>
>
> I can certainly sympathise with you, but I am not sure that data
> checksumming would help here.  If your hardware raid sends out nonsense,

Well, unfortunately, Bernd (and DDN et al) are right, it is helpful.  It 
has to be engineered correctly to be of use.  T10-DIF and PI are efforts 
in this direction.  This can be implemented in software.

> then it is going to be very difficult to get anything trustworthy.  The
> obvious answer here is to throw out the broken hardware raid and use a
> system that works - but it is equally obvious that that is easier said

... which is not so obvious when you start dealing with hundreds to TB 
and PB of data, and you have hardware which works perfectly most of the 
time (apart from a random cosmic ray, power fluctuation/surge, ...)

> than done!  But I would find it hard to believe that this is a common
> issue with hardware raid systems - it goes against the whole point of
> data storage.

http://storagemojo.com/2007/09/19/cerns-data-corruption-research/

(and no, I don't work for Robin, he largely ignores us :( )


> There is always a chance of undetected read errors - the question is if
> the chances of such read errors, and the consequences of them, justify
> the costs of extra checking.  And if they /do/ justify extra checking,

I guess the real question is, how valuable is your data ... if you took 
the trouble to store it, I am guessing that you'd like to know a) its 
stored correctly, b) it is retrievable, and c) what you retrieve is 
correct.

Hardware (and software) RAID help with b, and sometimes a.  C is what 
T10-DIF/PI and related are trying to solve.

> are data checksums the right way?  I agree with Neil's post that
> end-to-end checksums (such as CRCs in a gzip file, or GPG integrity
> checks) are the best check when they are possible, but they are not
> always possible because they are not transparent.

I personally would like to push the checking more into the file system 
layers  than the disk block layers.  Though I expect strong resistance 
to that as well.  File systems assume perfectly operating underlying 
storage blocks in most cases, and breaking that model (or breaking it 
any more than we are doing now) would be troubling to many.

Adding in crc verify on read (and crc generation and storage on write) 
shouldn't be too painful at the block layer.  Much of the infrastructure 
is in place.  I've been thinking of building a pluggable connection into 
MD, so we could experiment with different mechanisms (w/o rebuilding the 
kernel or MD each time).  Though this is (unfortunately) pretty far down 
our list of priorities at the moment.

>
> mvh.,
>
> David
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

