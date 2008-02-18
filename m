From: pg_lxra@lxra.to.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 to RAID6 reshape?
Date: Mon, 18 Feb 2008 19:05:02 +0000
Message-ID: <18361.55006.23018.546040@tree.ty.sabi.co.UK>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080217074526.29d3c5c5@hardcode42.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Sun, 17 Feb 2008 07:45:26 -0700, "Conway S. Smith"
>>> <beolach@gmail.com> said:

[ ... ]

beolach> Which part isn't wise? Starting w/ a few drives w/ the
beolach> intention of growing; or ending w/ a large array (IOW,
beolach> are 14 drives more than I should put in 1 array & expect
beolach> to be "safe" from data loss)?

Well, that rather depends on what is your intended data setup and
access patterns, but the above are all things that may be unwise
in many cases. The intended use mentioned below does not require
a single array for example.

However while doing the above may make sense in *some* situation,
I reckon that the number of those situations is rather small.

Consider for example the answers to these questions:

* Suppose you have a 2+1 array which is full. Now you add a disk
  and that means that almost all free space is on a single disk.
  The MD subsystem has two options as to where to add that lump
  of space, consider why neither is very pleasant.

* How fast is doing unaligned writes with a 13+1 or a 12+2
  stripe? How often is that going to happen, especially on an
  array that started as a 2+1?

* How long does it take to rebuild parity with a 13+1 array or a
  12+2 array in case of s single disk failure? What happens if a
  disk fails during rebuild?

* When you have 13 drives and you add the 14th, how long does
  that take? What happens if a disk fails during rebuild??

The points made by http://WWW.BAARF.com/ apply too.

beolach> [ ... ] media files that would typically be accessed
beolach> over the network by MythTV boxes.  I'll also be using
beolach> it as a sandbox database/web/mail server. [ ... ] most
beolach> important stuff backed up, [ ... ] some gaming, which
beolach> is where I expect performance to be most noticeable.

To me that sounds like something that could well be split across
multiple arrays, rather than risking repeatedly extending a
single array, and then risking a single large array.

beolach> Well, I was reading that LVM2 had a 20%-50% performance
beolach> penalty, which in my mind is a really big penalty. But I
beolach> think those numbers where from some time ago, has the
beolach> situation improved?

LVM2 relies on DM, which is not much slower than say 'loop', so
it is almost insignificant for most people.

But even if the overhead may be very very low, DM/LVM2/EVMS seem
to me to have very limited usefulness (e.g. Oracle tablespaces,
and there are contrary opinions as to that too). In your stated
applications it is hard to see why you'd want to split your
arrays into very many block devices or why you'd want to resize
them.

beolach> And is a 14 drive RAID6 going to already have enough
beolach> overhead that the additional overhead isn't very
beolach> significant? I'm not sure why you say it's amusing.

Consider the questions above. Parity RAID has issues, extending
an array has issues, the idea of extending both massively and
in several steps a parity RAID looks very amusing to me.

beolach> [ ... ] The other reason I wasn't planning on using LVM
beolach> was because I was planning on keeping all the drives in
beolach> the one RAID. [... ]

Good luck :-).
