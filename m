From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 25 Jan 2011 19:41:15 +0100
Message-ID: <20110125184115.1119FB187@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <20110125171017.GA24921@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110125171017.GA24921@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Christoph,

In message <20110125171017.GA24921@infradead.org> you wrote:
>
> > There may be 20...50 millions of files, or more. 65% of the files are
> > smaller than 4 kB; 80% are smaller than 8 kB; 90% are smaller than 16
> > kB; 98.4% are smaller than 64 kB.
> 
> I don't think you even want a RAID0 in that case.  For small IOPs
> you're much better off with a simple concatenation of devices.

What exactly do you mean by "conatenation"? LVM striping?
At least the discussion here does not show any significant advantages
for this concept:
http://groups.google.com/group/ubuntu-user-community/web/pick-your-pleasure-raid-0-mdadm-striping-or-lvm-striping

> > Should I do anything different to acchive maximum performance?
> 
> Make sure to disable the disk write caches and if not using the newest
> kernel also mount the filesystem with -o nobarrier.  With lots of small
> I/Os and metadata intensive workloads that's usually a lot faster.

Tests if done recently indicate that on the other hand nobarrier causes
a serious degradation of read and write performance (down to some 40%
of the values before).

> Also if you have a lot of log traffic an external log devices will
> help a lot.  It's doesn't need to be larger, but it will keep the
> amount of seeks on the other devices down.

Understood, thanks.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Never underestimate the bandwidth of a station wagon full of tapes.
                                -- Dr. Warren Jackson, Director, UTCS
