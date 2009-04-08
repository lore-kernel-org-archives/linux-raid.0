From: Andrew Burgess <aab@cichlid.com>
Subject: Re: RAID halting
Date: Wed, 08 Apr 2009 09:29:52 -0700
Message-ID: <1239208193.27764.9.camel@cichlid.com>
References: <F2C688D6A021E34CB81C0E631EF4C09301864D15@34093-C4-EVS1.exchange.rackspace.com>
	 <20090408141756.SJCK26228.cdptpa-omta04.mail.rr.com@Leslie>
	 <87f94c370904080737m2cc82712v3c02b072250f41a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370904080737m2cc82712v3c02b072250f41a7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>, linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2009-04-08 at 10:37 -0400, Greg Freemyer wrote:

> I think the only way to switch schedulers is to reboot.  You invoke
> the noop scheduler via a command line arg to the kernel at boot time.

This can be done at any time, no reboot required:

 for f in /sys/block/*/queue/scheduler; do
    echo noop > $f
    echo $f "$(cat $f)"
  done

Just FYI, I don't think ionice and friends will work when using noop.

Leslie: I still think finding out what the kernel is doing during the
stall would be a HUGE hint to the problem. Did you look into oprofile or
ftrace?


