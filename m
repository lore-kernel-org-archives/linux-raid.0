From: Janos Farkas <chexum+dev@gmail.com>
Subject: Re: which disk the the one that data is on?
Date: Wed, 19 Jul 2006 12:17:42 +0200
Message-ID: <priv$8d118c145637$7c55de2c5d@200607.shadow.banki.hu>
References: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com> <17596.41907.608404.634683@cse.unsw.edu.au> <e3edb0fa0607180223q11193d9ey6a6569bded1feb4@mail.gmail.com> <17596.44863.331069.588455@cse.unsw.edu.au> <e3edb0fa0607182233l2dd64395o884e523b7820676d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e3edb0fa0607182233l2dd64395o884e523b7820676d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2006-07-19 at 08:33:21, Shai wrote:
> Another question on this matter please:
> If there is a raid5 with 4 disks and 1 missing, and we add that disk,
> while its doing the resync of that disk, how do we know which disk it
> is (if we forgot what one we added)?

Everything is already in the /proc/mdstat (and mdadm -Q -D /dev/md0)
output you posted:

md0 : active raid5 hdd1[1] hdc1[0] hdh1[5](S) hdg1[4] hdf1[3] hde1[2]
     781433344 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
     [=>...................]  resync =  5.1% (9965184/195358336) finish=180.5min speed=17110K/sec

There's a number after each component (hdc1[0]), and there's an U in the
next line for each component.  If some of the component drives are not
there, or resyncing, something else will be there.  You can also see
that hdh1 is a (S)pare right now.  [_UUUU] would mean that the component
0 is not (U)p to date.  Make yourself familiar with this output so you
are not confused should there be any problem.

Similarly, mdadm output is containing largely the same information, but
in a different layout, maybe that's more clear in some cases.

Janos
