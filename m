From: Phil Turmel <philip@turmel.org>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Wed, 11 Feb 2015 19:15:57 -0500
Message-ID: <54DBF0BD.9040809@turmel.org>
References: <CAP7a4URzYsvw9aEd117FAs9_AE4fk1FuHQAmQQqreb3Y1yvOdg@mail.gmail.com>	<54DB6707.5030901@turmel.org> <CAP7a4UR1HzJ9AueEr1e=Zh5+p0=QgODA4=_Bp7bfQ=f2CwPhYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP7a4UR1HzJ9AueEr1e=Zh5+p0=QgODA4=_Bp7bfQ=f2CwPhYg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Logue <teque5@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/11/2015 05:12 PM, Kyle Logue wrote:
> Good news phil. Under the hypothesis that the new disk that I added
> didn't fully replace my sde I omitted it from my assemble. The array
> went full UUUUU, then I echo'd check > /sys/block/md0/md/sync_action
> 
> Much later it kicked out the faulty disk (previously sdc) and now i
> have a _UUUU.
> 
> So hopefully this is the final question, but should I just evacuate as
> much data as possible immediately? Or try to add another spare and
> rebuild?

So long as you haven't mounted it yet, I suggest you do another forced
assembly to get back to UUUUU, then kick off another check.  When many
UREs are allowed to accumulate, mdadm can hit its read error rate limit
and kick the drive.  If it hasn't been mounted, you can keep doing it
until you get through the entire check.

But, you also had misaligned partitions.  If sdcN is one of them, the
above won't work, and you should get your backups ASAP.  And then make a
new array from scratch.

If you do succeed in completing a check scrub, you can use --replace to
put the array on properly aligned partitions.

Phil
