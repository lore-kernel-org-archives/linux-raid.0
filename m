From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Mon, 10 Jun 2013 03:35:03 -0500
Message-ID: <51B58FB7.9080508@hardwarefreak.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com> <51B47088.4000501@redhat.com> <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com> <51B4F640.4030605@redhat.com> <CAO9HMNG8TaG3oTtmOcv8Zhe7_XghAzLLyEF5JwTpBAJfxhe+Qw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNG8TaG3oTtmOcv8Zhe7_XghAzLLyEF5JwTpBAJfxhe+Qw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/9/2013 6:08 PM, Steve Bergman wrote:
> And there are inevitable situations like last week when
> there was a(nother) power failure (I live in Oklahoma City) and the
> management and employees were scrambling to put everything on
> generators. The UPS didn't like the generator, and by the time they
> got the server back up it had crashed 5 times.

With all due respect Steve, your car has a hole in the exhaust and fumes
are entering the passenger cabin.  Instead of fixing the exhaust, you're
trying to roll down the windows to get the fumes out.

The problem is power, not Linux nor the filesystem.  So add more battery
packs to increase uptime, and implement apcupsd for clean shutdown on
low battery.  Avoiding unclean shutdowns due to power issues is a
problem solved long ago.  For this particular customer whose server went
down hard five times (there's no excuse for this BTW), this is a perfect
time to write a proposal for additional UPS hardware.  For the server
systems you've described, UPS+batteries for 12 hours of uptime is chump
change compared to lost revenue.  For any business in the Midwest, you
should have at least 12 hours of UPS time, or 1 hour UPS (cut at 30
mins) plus constantly tested and verified auto cutover to diesel
generator, which can be filled on the fly for indefinite power generation.

Storms usually arrive between late afternoon and during the overnight
hours.  Your biz power will normally go down during this time frame, and
multiple times while the power co is fixing downed lines.

I'm sure you'll come up with a list of reasons why they can't afford
more power backup, or that they shouldn't need it if filesystems just
worked "correctly", etc, etc.  They will all be invalid.

The simple fact is computers are powered by electricity.  If the current
stops flowing while they are running you will have problems, and not
just filesystems.  If they are properly powered down, they cannot be run
again until power is restored.

This is the problem you need to address.  Not filesystem "reliability".
 At minimum apcupsd should solve a lot of these problems.  But of course
you already know of apcupsd.  So why the 5 unclean shutdowns?

-- 
Stan

