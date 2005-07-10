From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: RAID1 assembly requires manual "mdadm --run"
Date: Sun, 10 Jul 2005 11:45:29 +0200
Message-ID: <62b0912f050710024556ca250b@mail.gmail.com>
References: <200506261621.01799.mlaks@verizon.net>
	 <62b0912f05070623185b90e732@mail.gmail.com>
	 <17102.26306.174427.502866@cse.unsw.edu.au>
	 <62b0912f05070811386bf7c72d@mail.gmail.com>
	 <17103.11260.748962.629919@cse.unsw.edu.au>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17103.11260.748962.629919@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday July 8, molle.bestefich@gmail.com wrote:
> > So a clean RAID1 with a disk missing should start without --run, just
> > like a clean RAID5 with a disk missing?

> Not that with /dev/loop3 no funcitoning,
>   mdadm --assemble --scan
> will still work.

Super!
That was exactly the point of the test.

You're correct, when I try again with a DEVICE line and --assemble
--scan, everything works perfectly.

(Not sure why Mitchell Laks saw something else happen.)

Thanks a lot for taking the time to answer questions, the information
is much appreciated!
