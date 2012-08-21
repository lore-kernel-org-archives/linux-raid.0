From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Tue, 21 Aug 2012 16:51:23 +0200
Message-ID: <5033A06B.30508@xs4all.net>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com> <201208152307.q7FN7hMR008630@xs8.xs4all.nl> <502CD3F8.70001@hardwarefreak.com> <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com> <5030F1C6.90205@hesbynett.no> <50317804.9010701@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50317804.9010701@hardwarefreak.com>
Sender: linux-kernel-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: David Brown <david.brown@hesbynett.no>, Michael Tokarev <mjt@tls.msk.ru>, Linux RAID <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On 08/20/2012 01:34 AM, Stan Hoeppner wrote:
> I'm glad you jumped in David.  You made a critical statement of fact
> below which clears some things up.  If you had stated it early on,
> before Miquel stole the thread and moved it to LKML proper, it would
> have short circuited a lot of this discussion.  Which is:

I'm sorry about that, that's because of the software that I use to 
follow most mailinglist. I didn't notice that the discussion was cc'ed 
to both lkml and l-r. I should fix that.

> Thus my original statement was correct, or at least half correct[1], as
> it pertained to md/RAID6.  Then Miquel switched the discussion to
> md/RAID5 and stated I was all wet.  I wasn't, and neither was Dave
> Chinner.  I was simply unaware of this md/RAID5 single block write RMW
> shortcut

Well, all I tried to say is that a small write of, say, 4K, to a 
raid5/raid6 array does not need to re-write the whole stripe (i.e. 
chunksize * nr_disks) but just 4K * nr_disks, or the RMW variant of that.

Mike.
