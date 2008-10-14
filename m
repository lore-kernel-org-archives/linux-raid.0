From: David Greaves <david@dgreaves.com>
Subject: non-degraded component replacement was Re: Distributed spares
Date: Tue, 14 Oct 2008 13:02:17 +0100
Message-ID: <48F48A49.2000200@dgreaves.com>
References: <48F3C2A1.3080607@tmr.com>	 <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan> <a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>, dean@arctic.org
List-Id: linux-raid.ids

Billy Crook wrote:
> It would be even nicer if there were a way to hot-transfer one
> raid component to another without setting anything faulty.  I suppose
> you could make all the components of the real array be single disk
> raid1 arrays for that purpose.  Then you could have one extra disk set
> aside for this sort of scrubbing, and never even be down one of your
> parities.  I guess I should add that onto my todo list....

IMHO This one should be high on the todo list. Especially if it's a
pre-requisite for other improvements to resilience.

Right now, if a drive fails or shows signs of going bad then you get into a very
 risky situation.

I'm sure most here know that the risk is because removing the failing drive and
installing a good one to re-sync puts you in a very vulnerable position; if
another drive fails (even one bad block) then you lose data.

The solution involves raid1 - but it needs a twist of raid5/6.

http://arctic.org/~dean/proactive-raid5-disk-replacement.txt

I think this is what was discussed:

Assume md0 has drives A B C D
D is failing
E is new

* add E as spare
* set E to mirror 'failing' drive D (with bitmap?)
* subsequent writes go to both D+E
* recover 99+% of data from D to E by simple mirroring
* any md0 or D->E read failures on D are recovered from reading ABC not E unless
E is in sync. D is not failed out. (and it's these tricks that stops users from
doing all this manually)
* any md0 sector read failure on ABC can still (hopefully) be read from D even
if not yet mirrored to E (also not possible
* once E is mirrored, D is removed and  the job is done


Personally I think this feature is more important than the reshaping requests;
of course that's just one opinion :)

David


