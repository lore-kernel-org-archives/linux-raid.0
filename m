From: =?ISO-8859-1?Q?Jarmo_J=E4rvenp=E4=E4?=
	<Jarmo.Jarvenpaa@softers.net>
Subject: Re: RAID 5 questions
Date: Mon, 02 Aug 2004 10:27:02 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <410DECC6.6040403@softers.net>
References: <1091325475.2374.11.camel@localhost> <20040801033109.GA23032@jim.sh> <410DD8AA.6060609@softers.net> <20040802060939.GA12472@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040802060939.GA12472@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: Ninti Systems <office@ninti.com.au>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jim Paris wrote:

> README.raid from lilo-22.5.9 (the latest version) states:
> 
> "Only RAID1 is supported.  LILO may be used to boot a system
> containing other RAID level partitions, but it may not be installed
> on any RAID partition other than RAID level 1."
> 
> so I don't believe you.  You may be confusing "booting off RAID-5"
> with "having a RAID-5 root".

Hmm, I'm not sure how to convince you :-)

The only possibility I can think of is that the lilos.conf's 
raid-extra-boot= -line affects the booting, thus it's silently booting 
from /dev/hdX and not from /dev/md0. I'm not sure how to test this though.


BR,
Jarmo

