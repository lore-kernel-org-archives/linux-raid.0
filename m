From: "NeilBrown" <neilb@suse.de>
Subject: Re: resync duration ?
Date: Sat, 16 May 2009 18:10:50 +1000 (EST)
Message-ID: <7316e2806a2a990a27f94982c44db035.squirrel@neil.brown.name>
References: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>
    <20090515050801951.MELG9927@cdptpa-omta04.mail.rr.com>
    <18957.58351.832772.646681@notabene.brown>
    <4A0E294C.8040201@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A0E294C.8040201@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, May 16, 2009 12:47 pm, Richard Scobie wrote:
> Neil Brown wrote:
>
>> Considered, yes.  But they are very low on my priority list.
>> I accept patches.
>> Maybe and option like
>>    mdadm --syncaction=check /dev/md0
>
> Perhaps it could also be incorporated in a manner similar to the way
> smartd allows for scheduled tests - a parameter added to each array in
> the mdadm.conf would allow scheduled checks when mdadm is run as a
> daemon.

Thanks for the suggestion...

However I have the strange and old-fashion notion that the strength
of Unix (which is one of the foundations of Linux) is the "tools
approach".  You have a tool for each job, and it does the job properly.

In the case of scheduled checks. cron is the tool of choice.

So if you want a monthly, or yearly, or daily check, get cron
to schedule it.

Just like if you want to be regularly reminded about degraded arrays,
get cron to run "mdadm -monitor --oneshot --scan" every morning.

I am definitely not interested in adding any scheduling capabilities
to mdadm.
(is smartd does scheduled checks... more fool them :-)

NeilBrown

