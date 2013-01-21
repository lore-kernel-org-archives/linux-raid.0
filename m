From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Suboptimal raid6 linear read speed
Date: Mon, 21 Jan 2013 20:32:00 +0000
Message-ID: <20733.42432.839120.845767@tree.ty.sabi.co.uk>
References: <20130115125507.GA12184@rabbit.us>
  <50F614F7.20104@hardwarefreak.com>
  <20130116025857.GA31112@rabbit.us>
  <50F70DB7.6020104@hardwarefreak.com>
  <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
  <50F90857.3010305@hardwarefreak.com>
  <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
  <50F9D32F.7090606@hardwarefreak.com>
  <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
  <20732.17741.587765.199649@tree.ty.sabi.co.uk>
  <20130121144039.GA4103@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130121144039.GA4103@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... RAID6 reading suffering from "skipping" over parity blocks
... ]

> I was indeed very surprised to find out that the skipping is
> *not* free.

Uhmmm :-).

> I am planning to do some research on whether it is possible to
> use specific chunksizes so that when laid out on top of the
> physical media the "skip penalty" is minimized. [ ... ]

Oh no, that does not address the issue. The issue is that
whatever happens in an N+M RAID[56...], a fraction M/N of the
data is not relevant for reading, and that if one does a simple
mapping M/N of the drives won't be "active" at any one point.
Since usually (and unfortunately) N>>M (that is, very wide
RAID[56...] sets) not many people worry about that.

The only "solution" that seems practical to me is a "far" layout
as in the MD RAID10, generalizing it, that is laying data and
"parity" blocks not across the drives, but along them; for the
trivial and not so clever case, to put the "parity" blocks on
the same drive(s) as the stripe they relate to. But obviously
that does not have redundancy, so like in the MD RAID10 "far"
layout, the idea is to move stagger/diagonalize them to the next
drive.

For example, in a 2+2 layout like yours, each drive is divided
in two regions, the top one for data, the bottom one for parity,
and the first two stripes are laid out like this:

   A       B       C       D
----------------------------
[0:0     0:1]   [1:0     1:1]
[2:0     2:1]   [3:0     3:1]
....    ....    ....    ....
....    ....    ....    ....
----------------------------
....    ....    ....    ....
....    ....    ....    ....
[3:P     3:Q]   [2:P     2:Q]
[1:P     1:Q]   [0:P     0:Q]
----------------------------

and the 4+1 case would be:

   A       B       C       D       E
------------------------------------
[0:0     0:1     0:2     0:3]   [1:0
 1:1     1:2     1:3]   [2:0     2:1
 2:2     2:3]   [3:0     3:1     3:2
 3:3]   [4:0     4:1     4:2     4:3]
....    ....    ....    ....    ....
....    ....    ....    ....    ....
....    ....    ....    ....    ....
....    ....    ....    ....    ....
------------------------------------
....    ....    ....    ....    ....
[4:P]   [3:P]   [2:P]  [1:P]    [0:P]
------------------------------------

and for "fun" this is the 3+3 case:

  A       B       C       D       E       F
--------------------------------------------
[0:1     0:1     0:2]   [1:0     1:1     1:2]
[2:0     2:1     2:2]   [3:0     3:1     3:2]
....    ....    ....    ....    ....    ....
....    ....    ....    ....    ....    ....
--------------------------------------------
....    ....    ....    ....    ....    ....
....    ....    ....    ....    ....    ....
[3:P     3:Q     3:R]  [2:P     2:Q     2:R]
[1:P     1:Q     1:R]  [0:P     0:Q     0:R]
--------------------------------------------

More generally, given a N data blocks and M "parity" blocks per
stripe, each drive is divided two areas, a data one N/(N+M) of
the disk capacity, a "parity" one M/(N+M) of the disk capacity
and:

  - The N blocks long data parts of each stripe are written
    consecutively in the data areas across the N+M RAID set
    members.
  - The M blocks long "parity" parts of each stripe are written
    consecutively *backwards* from the *end* of the "parity"
    areas across the N+M RAID set members.

This ensures that each N and M blocks long parts of each stripe
are written on different disks, staggered neatly.

The ordinary layout is one in which one divides the stripes in
one section only. One can generalize with other stripe and block
within stripe distribution functions too, including those that
might subdivide a stripe (and thus each disk in the RAID set) in
more than 2 parts, but I don't see much point in that, except
for RAID1 1+N where for example each of the N can be considered
an indepedent "parity".

  Note: RAID10 "far" should also write the mirror from the end,
  and arguably RAID1 should mirror backwards too (woudl give
  nicely uniform average IO rates depsite the speed difference
  between inner and outer tracks. Of course one could write the
  "parity" section of each stripe backwards in each row starting
  with the first row, but I like better the fully inverted
  layout...  But it may not be practical with disk scheduling
  algorithms that probably prefer forwards seeking.

But just as "far" RAID10 pays for better single threaded reading
with slower writing, "far" RAID[56...] (or any other, as the
"far" layout is easy to generalize) pays for greater reading
speed in the optimal case with even more terrible writing or
incomplete or resync reading, because to read two consecutive
stripe requires seeking across some of the disks.
