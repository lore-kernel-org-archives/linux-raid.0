From: Phil Turmel <philip@turmel.org>
Subject: Re: question about the best suited RAID level/layout
Date: Fri, 05 Jul 2013 09:36:57 -0400
Message-ID: <51D6CBF9.2020100@turmel.org>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372978687.5249.52.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/04/2013 06:58 PM, Christoph Anton Mitterer wrote:
> Hi Phil.
> 
> On Thu, 2013-07-04 at 17:43 -0400, Phil Turmel wrote:
>>> The focus is absolutely on data security/resilience,... and not at all
>>> on performance.
>> This particular statement trumps all other considerations.
> Sarcasm? (*Sheldon Cooper hat on*)

No sarcasm.  Speed, redundancy, capacity.  Pick two.  Any gain in one of
those criteria must reduce one or both of the others.  (Not really
binary on each, but you get the idea.)

You picked "redundancy".  Leaves only only one axis to consider: speed
vs. capacity.

>> Triple-copy raid10
>> across four drives can match that resiliency, with dramatically better
>> performance, but with a substantial cost in capacity.
> hmm I've briefly thought about that as well (just forgot to mention
> it)... for some reason (probably a non-reason) I've always had a bad
> feeling with respect to that uneven mixing (i.e. three copies on four
> disks), AFAIU that would look like (each same number being the same
> chunck:
> +---------+ +---------+ +---------+ +---------+
> |   sda   | |   sdb   | |   sdc   | |   sdd   |
> +---------+ +---------+ +---------+ +---------+
>   0  1  2     0  1  3     0  2  3     1  2  3
>   4  5  6     4  5  7     4  6  7     5  6  7
>   8  9  10    8  9  11    8  10 11    9  10 11

Precisely.  This is "raid10,near3".  You can look up the "offset" and
"far" variants.

> And that gives me again, any 2 disks... but so much better performance?

Dramatically.

> With 4x 4TiB disks,.. RAID6 would give me 16/2 TiB... and the above
> would give me 16/3 TiB?!
> Quite a loss...

Yup.

> And AFAIU it doesn't give me any better resilience than RAID6 (by tricks
> like probabilities or so)?

At four drives, no.  Any two.  With five, there are some combinations of
three missing drives that'll still run.

> Can it be grown? Like when I want to use the 5th bay? What would it be
> then, still any 2 out of 5?

No.

>> Two-failure resilience is vital to completing recovery after replacing a
>> failed drive, particularly when the read error rates of consumer-grade
>> drives are involved.
> Well,... I have enterprise disks, and I have backups on different
> media,... but nevertheless,... I wouldn't "risk" RAID5 for my precious
> data

IMHO, enterprise drives and a good backup regime makes raid5 a
reasonable choice.  Raid gives you uninterrupted *uptime* in the face of
hardware failure, and only hardware failure.  But David already covered
that.

>> In your specific case, raid6 has one additional advantage: making future
>> expansion to the fifth bay a reliable, simple, no downtime event.
> Ah... so I couldn't online/offline grow a RAID10 with n/f/o=3 ?

No.

>> In your situation, I would use raid6.  To mitigate the performance hit
>> on occasional random-access work, I would use a small chunk size (I use
>> 16k).  That will somewhat hurt peak linear performance, but even
>> bluray-equivalent media streams only amount to 5 MB/s or so.  That would
>> be 80 IOPS per device in such a four-drive raid6.
> I think RAID6 will be what I go for, at least unless the RAID10 with
> three blocks gives me any resilience bonus, which I can't see right now.
> 
> Any ideas about the layout? i.e. left-symmetric-6, right-symmetric-6,
> left-asymmetric-6, right-asymmetric-6, and parity-first-6 ?

Certainly not any of the "-6" suffixes.  Those isolate Q on the last
disk, hurting streaming performance, and setting up the possibility of
uneven performance when degraded.  The default left-symmetric gives the
best chunk distribution for general use.

Phil
