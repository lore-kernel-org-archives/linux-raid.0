From: Al Boldi <a1426z@gawab.com>
Subject: Re: Propose of enhancement of raid1 driver
Date: Mon, 30 Oct 2006 18:44:56 +0300
Message-ID: <200610301844.56901.a1426z@gawab.com>
References: <45347D6E.3000600@mieszczak.com.pl> <200610282031.07893.a1426z@gawab.com> <ei0elo$23m$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ei0elo$23m$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > But what still isn't clear, why can't raid1 use something like the
> > raid10 offset=2 mode?
>
> RAID1 has equal data on all mirrors, so sooner or later you have to seek
> somewhere - no matter how you layout the data on each mirror.

Don't underestimate the effects mere layout can have on multi-disk array 
performance, despite it being highly hw dependent.

The best approach would probably involve a user-configurable layout table, to 
tune it to the specific hw.


Thanks!

--
Al

