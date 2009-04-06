From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 20:53:56 -0500
Message-ID: <20090406015357.NYON1944.cdptpa-omta02.mail.rr.com@Leslie>
References: <783F1304-DEE5-4495-A81A-B98A5EDCCABF@redhat.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <783F1304-DEE5-4495-A81A-B98A5EDCCABF@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Well said.  I found it particularly interesting to hear David talk of
> statistical probabilities as he studiously ignored the astronomical
> statistical improbability that sector remapping would strike only on
> file creation, and would simultaneously block a drive up for the
> purpose of file creation but not block it up for the purpose of raid
> sector checking.

I know.  I was apoplectic.  I truly didn't know how best to respond to such
a glaring incongruity.  It's likely the average sector in the free space
region has been read 50 times or more without a single instance of the
failure, yet under load every single creation causes a halt.  'Billions of
sectors read over, and over, and over again, yet perform a file create to
one or two from the very same sector space, and kerplewey!  It boggled my
mind.

> David definitely went on a "short bus" rant, I'd
> just ignore the rant

I was trying to, mostly.  I've never heard the term, "short bus", before.  I
presume it refers to what can happen on a computer bus with an electrical
short?  What really gets me is rather than going on and on about how
ignorant I was, all he had to do in his very first message was say, "Try the
badblocks command."

> Personally, I've
> only ever used badblocks for low level disk checking, but back when I
> used it for diagnosis drives were different than they are today in
> terms of firmware and you could actually trust that badblocks was
> doing something useful.

Am I mistaken in believing, per the discussion in this list, it should
trigger an event, provided the problem really is bad blocks on one or more
drives?  If so, then I need someone to explain a bit more what badblocks
does, and perhaps point me toward some low level test which will potentially
either rule out or convict the drive layer of being the source of issues.
I've never used it before, quite obviously.  I read the MAN page, of course,
but as is typical with MAN pages, it doesn't go into any detail under the
hood, as it were.

Oh, just BTW, I have the system set to notify me via e-mail of any events
passing through the Monitor daemon of mdadm.  Will this notify me if the
RAID device encounters any errors requiring recovery at the RAID level?  If
so, I have never received any such notifications since implementing mdadm.

