From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: 4 questions. Chieftec chassis case CA-01B, resync times, selecting ide driver module loading,  raid5 :2 drives on same ide channel
Date: Sun, 16 Jan 2005 16:58:45 -0500
Message-ID: <200501162156.j0GLup926376@www.watkins-home.com>
References: <200501162155.46495.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501162155.46495.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, RedHat 9 defaults to much less, 10,000 I think.

I assumed it was the md default.  Maybe a RedHat 9 issue.

I just looked at the man page for md.  It says "The default is 100,000.".  I
did upgrade to Kernel 2.4.28 a few weeks ago.  I guess the default was
changed in a newer version of md.

My /etc/sysctl.conf has a date of Dec 12, 2003.  So, whatever kernel I had
over 1 year ago had a default of 10,000, or so.

Anyway, it has helped some people in the past. :)
I guess it depends on the kernel/md version.

I guess a default of no limit would be nice.  But no support for that, yet!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Maarten
Sent: Sunday, January 16, 2005 3:56 PM
To: linux-raid@vger.kernel.org
Subject: Re: 4 questions. Chieftec chassis case CA-01B, resync times,
selecting ide driver module loading, raid5 :2 drives on same ide channel

On Sunday 16 January 2005 20:39, Guy wrote:
> If your rebuild seems too slow, make sure you increase the speed limit!
> Details in "man md".
>
> echo 100000 > /proc/sys/dev/raid/speed_limit_max

Hi Guy,
You always say that, but that never helps me (since my distro already has 
100000 as default).  Are there even distros that have this set too low ? 

Maarten


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

