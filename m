From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 20:52:21 +0100
Message-ID: <200501032052.21459.maarten@ultratux.net>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501031846.42950.maarten@ultratux.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 03 January 2005 18:46, maarten wrote:
> On Monday 03 January 2005 12:31, Peter T. Breuer wrote:
> > Guy <bugzilla@watkins-home.com> wrote:


>
> Doing the math, the outcome is still (200% divided by four)= 50%.
> Ergo: the same as with a single disk.  No change.


Just for laughs, I calculated this chance also for a three-way raid-1 setup 
using a lower 'failure possibility' percentage.  The outcome does not change.
The (statisticly higher) chance of a disk failing is exactly offset by the 
greater likelyhood that the raid system chooses one of the good drives to 
read from.
(Obviously this is only valid for raid level 1, not for level 5 or others)


Let us (randomly) assume there is a 10% chance of a disk failure.
We use three raid-1 disks, numbered 1 through 3.

We therefore have eight possible scenarios:

A
disk1 fail
disk2 good
disk3 good

B
disk1 good
disk2 fail
disk3 good

C
disk1 good
disk2 good
disk3 fail

D
disk1 fail
disk2 fail
disk3 good

E
disk1 fail
disk2 good
disk3 fail

F
disk1 good
disk2 fail
disk3 fail

G
disk1 fail
disk2 fail
disk3 fail

H
disk1 good
disk2 good
disk3 good

Scenarios A, B and C are similar (one disk failed). Scenario's D, E and F are 
also similar (two disk failures).  Scenarios G and H are special, the chances 
of that occurring are calculated seperately.

H: the chance of all good disks is (0.9x0.9x0.9) = 0.729
G: the chance of all disks bad is (0.1x0.1x0.1) = 0.001
The chance of A, B or C (one bad disk) is (0.9x0.9x0.1) = 0.081
The chance of D, E or F (two bad disks) is (0.9x0.1x0.1) = 0.009

The chance of (A, B or C) and (D, E or F) occurring must be multiplied by 
three as there are three scenarios each. So this becomes: 
The chance of one bad disk is = 0.243
The chance of two bad disks is = 0.027

Now let's see. It is certain that the raid subsystem will read the good data 
in H. The chance of that in scenario G is zero. The chance in (A, B or C) is 
two-thirds. And for D, E or F the chance the raid system getting the good 
data is one-third.

Let's calculate all this.
[ABC] x 0.667 = 0.243 x 0.667 = 0.162
[DEF] x 0.333 = 0.027 x 0.333 = 0.008
[G] x 0 = 0.0 
[H] x 1.0 = 0.729

(total added up is 0.9)

Conversely, the chance of reading the BAD data:
[ABC] x 0.333 = 0.243 x 0.333 = 0.081
[DEF] x 0.667 = 0.027 x 0.667 = 0.018
[G] x 1.0 = 0.001 
[H] x 0.0 = 0.0

(total added up is 0.1)

Which, again, is exactly the same chance a single disk will get corrupted, as 
we assumed above in line one is 10%.  Ergo, using raid-1 does not make the 
risks of bad data creeping in any worse.  Nor does it make it better either.

Maarten

