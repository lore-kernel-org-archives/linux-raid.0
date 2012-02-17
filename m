From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Fri, 17 Feb 2012 07:16:21 -0600
Message-ID: <4F3E5325.3060001@hardwarefreak.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com> <20120215083058.GA8821@cthulhu.home.robinhill.me.uk> <4F3BB385.4000608@hardwarefreak.com> <4F3BD1F6.8080309@westcontrol.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3BD1F6.8080309@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/15/2012 9:40 AM, David Brown wrote:

> Like Robin said, and like I said in my earlier post, the second copy is
> on a different disk.

We've ended up too deep in the mud here.  Keld's explanation didn't make
sense resulting in my "huh" reply.  Let's move on from there back to the
real question.

You guys seem to assume that since I asked a question about the near,far
layouts that I'm ignorant of them.  These layouts are the SNIA
integrated adjacent stripe and offset stripe mirroring.  They are well
known.  This is not what I asked about.

> As far as I can see, you are the only one in this thread who doesn't
> understand this.  I'm not sure where the problem lies, as several people
> (including me) have given you explanations that seem pretty clear to me.
>  But maybe there is some fundamental point that we are assuming is
> obvious, but you don't get - hopefully it will suddenly click in place
> for you.

Again, the problem is you're assuming I'm ignorant of the subject, and
are simply repeating the boiler plate.

> Forget writes for a moment.[snip]

This saga is all about writes.  The fact you're running away from writes
may be part of the problem.

Back to the original issue.  Coolcold and I were trying to figure out
what the XFS write stripe alignment should be for a 7 disk mdraid10 near
layout array.

After multiple posts from David, Robin, and Keld attempting to 'educate'
me WRT the mdraid driver read tricks which yield an "effective RAID0
stripe", nobody has yet answered my question:

What is the stripe spindle width of a 7 drive mdraid near array?

Do note that stripe width is specific to writes.  It has nothing to do
with reads, from the filesystem perspective anyway.  For internal array
operations it will.

So lets take a look at two 4 drive RAIDs, a standard RAID10 and a
RAID10,n/f.  The standard RAID10 array has a stripe across two drives.
Each drive has a mirror.  Stripe writes are two device wide.  There are
a total of 4 write operations to the drives, 2 data and two mirror data.
 Stripe width concerns only data.

The n,r rotate the data and mirror data writes around the 4 drives.  So
it is possible, and I assume this is the case, to write data and mirror
data 4 times, making the stripe width 4, even though this takes twice as
many RAID IOs compared to the standard RAID10 lyout.  If this is the
case this is what we'd tell mkfs.xfs.  So in the 7 drive case it would
be seven.  This is the only thing I'm unclear about WRT the near/far
layouts, thus my original question.  I believe Neil will be definitively
answering this shortly.

There is a potential problem with this though, if my assumption about
write behavior of n/f is correct.  We've now done 8 RAID IOs to the 4
drives in a single RAID operation.  There should only be 4 RAID IOs in
this case, one to each disk.  This tends to violate some long accepted
standards/behavior WRT RAID IO write patterns.  Traditionally, one RAID
IO meant only one set of sector operations per disk, dictated by the
chunk/strip size.  Here we'll have twice as many, but should
theoretically also be able to push twice as much data per RAID write
operation since our stripe width would be doubled, negating the double
write IOs.  I've not tested these head to head myself.  Such results
with a high IOPS random write workload would be interesting.

-- 
Stan
