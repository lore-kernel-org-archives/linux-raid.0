From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or destructive
 result?
Date: Wed, 27 Mar 2013 17:08:29 -0500
Message-ID: <51536DDD.5010800@hardwarefreak.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra> <51534450.8050905@hardwarefreak.com> <CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com> <51535252.2080105@hardwarefreak.com> <CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/27/2013 4:06 PM, Mark Knecht wrote:

> All that said, I still don't really know if I was starting over today
> how to choose a new chunk size. That still eludes me. I've sort of
> decided that's one of those things that make you guys pros and me just
> a user. :-)

Chunk size is mostly dictated by your workload IO patterns, and the
number and latency of your spindles.  If you're doing mostly small
random IOs, or mixed IOs, metadata heavy workloads, you typically want a
small chunk size, especially if the array is parity (5/6).  RMW is the
performance killer here so you want to minimize--a small chunk size does
this.  If you're doing mostly large streaming writes then you want a
larger chunk size to improve IO efficiency in the elevator and the
drive's write caches, command queuing, etc.  The filesystem you use, and
how it arranges inodes/extents across sectors, can play a role as well.

When in doubt, use a small chunk size.  The reason is this:  a large
chunk can drive small random IO performance into the dirt if you're
using parity or really low RPM low IOPS drives, but a small chunk will
not have anywhere close to the same negative impact on large streaming IO.

A 5 drive RE4 RAID6 array with a 16KB chunk, 48KB stripe, is about as
small as you'd want to go.  It's optimal for small random IO, but it's
probably a bit too small for a mixed workload, and definitely too small
for streaming.  With only 3 slow spindles, a 32KB or even 64KB chunk may
be more optimal, yielding a 96KB or 192KB stripe.  This depends, again,
on your workload(s).  If most of your write IOs are between 48-96KB then
use a 16KB chunk.  If most are between 96-192KB use a 32KB chunk.  If
between 192-384KB then use a 64KB chunk, and so on.

If you're using SSDs the game changes quite a bit as neither random IO
nor RMW latency is an issue.  With SSD, when in doubt, use a large chunk
size, preferably equal to the erase block size, or a power of 2 fraction
of it.

-- 
Stan

