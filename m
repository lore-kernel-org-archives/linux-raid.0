From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Help: very slow software RAID 5.
Date: Tue, 18 Sep 2007 18:49:19 -0700 (PDT)
Message-ID: <20070919014919.DF19D10215F@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan> (message
	from Justin Piszcz on Tue, 18 Sep 2007 20:05:01 -0400 (EDT))
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Justin Piszcz wrote:
On Tue, 18 Sep 2007, Dean S. Messing wrote:
: 
: >
: >
: > I'm not getting nearly the read speed I expected
: > from a newly defined software RAID 5 array
: > across three disk partitions (on the 3 drives,
: > of course!).
: >
: > Would someone kindly point me straight?
: >
: > After defining the RAID 5 I did `hdparm -t /dev/md0'
: > and got the abysmal read speed of ~65MB/sec.
: > The individual device speeds are ~55, ~70,
: > and ~75 MB/sec.
: >
: > Shouldn't this array be running (at the slowest)
: > at about 55+70 = 125 MB/sec minus some overhead?
: > I defined a RAID0 on the ~55 and ~70 partitions
: > and got about 110 MB/sec.
: >
: > Shouldn't adding a 3rd (faster!) drive into the
: > array make the RAID 5 speed at least this fast?
: >
: >
: > Here are the details of my setup:
: >

<snip>

: Without tuning you will get very slow read speed.
: 
: Read the mailing list, there are about 5-10 tunable options, for me, I get 
: 250 MiB/s no tuning (read/write), after tuning 464 MiB/s write and 622 
: MiB/s read.
: 
: Justin.

Thanks Justin.

5-10 tunable options!  Good grief.  This sounds worse than regulating
my 80 year old Grandfather Clock.  (I'm quite a n00bie at this.)  Are
there any nasty system side effects to tuning these parameters?  This
is not a server I'm working with.  It's my research desktop machine.
I do lots and lots of different things on it.

I started out with RAID 0, but after reading a lot I learned that this
is Dangerous.  So I bought a 3rd disk to do RAID 5.  I intend to put
LVM on top of the RAID 5 once I get it running at the speed it is
supposed to, and then copy my entire linux system onto it.  Are these
tuned parameters going to mess other things up?

Is there official documentation on this relative to RAID 5?  I don't
see much online.

One thing I did learn is that if I use the "--direct" switch with
`hdparm' I get much greater read speed.  Goes from ~65 MB/s to ~120 MB/s.

I have no idea what --direct does. Yes, I've read the man page.
It says that it causes bypassing of "the page cache".  Ooookay.

Alas using "dd" I find that the "real read speed" is still around ~65 MB/s.

Sorry for these musings.  I'm just uncomfortable trying to diddle
with 5-10 system parameters without knowing what I'm doing.

Any help or pointers to documentaion on tuning these for RAID-5 and what
the tradeoffs are would be appreciated.

Thanks.
Dean

