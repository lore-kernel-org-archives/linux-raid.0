From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: Linux drivers for ICH5R (RAID1) and Promise PDC20378, Performance
Date: Tue, 14 Oct 2003 00:23:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310140023.13957.dusty@strike.wu-wien.ac.at>
References: <200310140008.43189.dusty@strike.wu-wien.ac.at> <1066083358.4761.254.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1066083358.4761.254.camel@persist.az.mvista.com>
Content-Disposition: inline
To: sdake@mvista.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday 14 October 2003 00:15, Steven Dake wrote:
> On Mon, 2003-10-13 at 15:08, Hermann Himmelbauer wrote:
> > Moreover I would like to know which filesystem would suit best. For the
> > HW-RAID solutions this should not make any difference but I heard that
> > e.g. ReiserFS + Linux SW-RAID is quite slow.
>
> I use ext3 + raid1 with two western digital 8MB cache disks.  I get
> about 65mb/sec sustained read performance.  With one disk, I get about
> 40mb/sec sustained read performance.  The linux raid code read balances
> across disks, but doesn't write balance.

Thank you for your quick answer.
This sounds interesting, but what is the CPU Load of your System when 
reading/writing with full speed? (e.g. cat big-file > /dev/null)
I read that the ICH5R and the Promise use only ~ 3% of the CPU.

		Best Regards,
		Hermann

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

