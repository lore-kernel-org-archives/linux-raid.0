From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID-6 horizontal grow
Date: Sat, 11 Apr 2009 19:53:54 +1000 (EST)
Message-ID: <bf90f0dca1b3c313c8ef5e74a4648938.squirrel@neil.brown.name>
References: <20090410215435.GA10451@lazy.lzy>
    <20090410215833.GF21242@cthulhu.home.robinhill.me.uk>
    <20090410223433.GA10797@lazy.lzy> <20090411082348.GA3983@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090411082348.GA3983@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, April 11, 2009 6:23 pm, Piergiorgio Sartor wrote:
> Hi again,
>
> I answer to myself.
>
> It seems that the array needs to be assembled
> with "--update devicesize", so that later the
> "--grow --size=max" could really work.

I love it when people find out answers by themselves - it shows the
documentation isn't completely worthless :-)

>
> It also seems that "--update" works only with
> "--assemble".
> Is there any way to update the device size "live",
> i.e. without stopping and re-assembling the array?
> (and without failing/removing/adding components?).

I think so, but mdadm cannot do it for you (yet).

If you
  for i in /sys/block/mdX/md/dev-*/size
  do echo 0 > $i
  done

it will have much the same effect as --assemble --update devicesize

Then you can
   --grow --size=max

NeilBrown

