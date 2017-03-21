From: David Brown <david.brown@hesbynett.no>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 15:26:38 +0100
Message-ID: <58D1381E.1080101@hesbynett.no>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au> <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com> <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <58D1244E.3040204@hesbynett.no> <CAJH6TXih4wv10WDGOA2PT-b8FSetx06D237HS_cpT4+Ap0d0dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXih4wv10WDGOA2PT-b8FSetx06D237HS_cpT4+Ap0d0dg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/17 14:26, Gandalf Corvotempesta wrote:
> 2017-03-21 14:02 GMT+01:00 David Brown <david.brown@hesbynett.no>:
>> Note that to cause failure in non-degraded RAID5 (or degraded RAID6),
>> your two URE's need to be on the same stripe in order to cause data
>> loss.  The chances of getting an URE somewhere on the disk are roughly
>> proportional to the size of the disk - but the chance of getting an URE
>> on the same stripe as another URE on another disk are basically
>> independent of the disk size, and it is extraordinarily small.
> 
> Little bit OT:
> is this the same even for HW RAID Controllers like LSI Megaraid
> or they tend to fail the rebuild in case of multiple URE even in
> different stripes?

It should be true, for decent HW RAID setups.  One possible problem is
the famous re-read timeouts - if you use a consumer hard drive with long
re-read timeouts, and have not (or cannot) configure it to have a short
timeout, then a hardware RAID controller might consider a drive to be
completely dead while the drive is simply spending 30 seconds re-trying
its read.  If the raid controller drops the drive, then it is like an
URE in /all/ stripes at once!

> 
>> No, you cannot.  Your conclusion here is based on several totally
>> incorrect assumptions:
>>
>> 1. You think that RAID5/RAID6 recovery is more stressful, because the
>> parity is "all over the place".  This is wrong.
>>
>> 2. You think that random IO has higher chance of getting an URE than
>> linear IO.  This is wrong.
> 
> Totally agree.
> 
>> 3. You think that getting an URE on one disk, then getting an URE on a
>> second disk, counts as a double failure that will break an single-parity
>> redundancy (RAID5, RAID1, RAID6 in degraded mode).  This is wrong - it
>> is only a problem if the two UREs are in the same stripe, which is quite
>> literally a one in a million chance.
> 
> I'm not sure about this.
> The posted paper is talking about "standard" raid made with hw raid controllers
> and I'm not sure if they are able to finish a rebuild in case of double URE even
> if coming from different stripes.
> 
> I think they fail the whole rebuild.
> 

I cannot imagine why that would be the case.

Suppose you have seven drive RAID6, with data blocks ABCDE and parities
PQ.  To make it simpler, assume that on this particular stripe, the
order is ABCDEPQ.  If drive 5 has failed and you are rebuilding, the
RAID system will read in ABCD-P-.  It will not read from drive 5 (since
you are rebuilding it), and it will not bother reading drive 7 because
it doesn't need the Q parity (it /might/ read it in as part of a
streamed read).  It calculates E from ABCD and P, and writes it out.
If, for example, drive 3 gets an URE at this point then it will read the
Q parity and calculate C and E from ABD P and Q.  It will write out E to
the rebuild drive, and also C to the drive with the URE - the drive will
handle sector relocation as needed.  The result is that the stripe
ABCDEPQ is correct on the disk.  The drive with the URE will not be
dropped from the array.

Then it moves on to the next stripe, and repeats the process.  An URE
here is independent of an URE in the previous stripe, and errors can
again be corrected.

It is possible that if there are a large number of UREs from a drive,
that the RAID system will consider the whole drive bad and drop it.  But
other than that, UREs will be treated independently.

