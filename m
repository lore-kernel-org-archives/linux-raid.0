From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Catching a RAID error in a process
Date: Thu, 19 Jul 2012 10:40:14 -0400
Message-ID: <50081C4E.90708@tmr.com>
References: <50071D3B.3090309@tmr.com> <20120719090045.361edaef@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120719090045.361edaef@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Wed, 18 Jul 2012 16:31:55 -0400 Bill Davidsen <davidsen@tmr.com> wrote:
>
>> Can someone point me to the docs to have a process run or notified when a RAID
>> event triggers? I've been playing with some recovery ideas, but polling states
>> and status is not the proper way to do this, and I want to test with a user
>> program before I start putting patches in the kernel.
>>
> I guess you don't mean "run mdadm --monitor --program /bin/myscript" ??
>
> Do you want "just any event" or some specific set of events?
>
> See mdstat_wait in mdstat.c in the mdadm sources.  It waits for any event by
> using 'select' on /proc/mdstat.
>
> void mdstat_wait(int seconds)
> {
> 	fd_set fds;
> 	struct timeval tm;
> 	int maxfd = 0;
> 	FD_ZERO(&fds);
> 	if (mdstat_fd >= 0) {
> 		FD_SET(mdstat_fd, &fds);
> 		maxfd = mdstat_fd;
> 	}
> 	tm.tv_sec = seconds;
> 	tm.tv_usec = 0;
> 	select(maxfd + 1, NULL, NULL, &fds, &tm);
> }
>
>
> mdstat_fd is a global variable
>      mdstat_fd = open("/proc/mdstat", O_RDONLY);
>
> NeilBrown
I would probably just use the ptail program to do it that way, I was hoping 
there was some neat other way to be notified when something _bad_ happens.  This 
is relative to the RAID5e stuff I discussed years ago, I think I know how to do 
it now, the steps work if I enter the commands manually, now I have to get a 
user program to do it, and finally we can discuss the possibility of putting it 
in the kernel.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


