From: Jim Paris <jim@jtan.com>
Subject: Re: RAID 5 questions
Date: Mon, 2 Aug 2004 02:09:40 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040802060939.GA12472@jim.sh>
References: <1091325475.2374.11.camel@localhost> <20040801033109.GA23032@jim.sh> <410DD8AA.6060609@softers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <410DD8AA.6060609@softers.net>
To: Jarmo =?iso-8859-1?B?SuRydmVucOTk?= <Jarmo.Jarvenpaa@softers.net>
Cc: Ninti Systems <office@ninti.com.au>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Umm, I maybe writing on complitely different setup (can't check the 
> original post), but our server with software raid 5 (3 disks) is booting 
> with lilo just fine.

README.raid from lilo-22.5.9 (the latest version) states:

"Only RAID1 is supported.  LILO may be used to boot a system
containing other RAID level partitions, but it may not be installed
on any RAID partition other than RAID level 1."

so I don't believe you.  You may be confusing "booting off RAID-5"
with "having a RAID-5 root".

-jim
