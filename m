From: Neil Brown <neilb@suse.de>
Subject: Re: Controlling Reading and Writing in RAID 1 configuration
Date: Fri, 28 Apr 2006 08:04:49 +1000
Message-ID: <17489.16385.884347.871210@cse.unsw.edu.au>
References: <20060425125814.6366.qmail@web52907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rik Herrin on Tuesday April 25
Sender: linux-raid-owner@vger.kernel.org
To: Rik Herrin <rikherrin@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 25, rikherrin@yahoo.com wrote:
> Hi,
>   I have a setup where I want to use RAID 1 to mirror
> my data over the LAN.  I am exposing 2x500 GB-sized
> devices via iSCSI and was wondering if I could
> configure the RAID 1 to write to both members of the
> RAID 1 configuration but only read from one as one
> link is 1GbE while the other is lower but sufficient
> for writing.  Is this possible? Thanks for your help.

You'll be wanting the '--write-mostly' option to mdadm.
This requires a fairly recent kernel and mdadm.

NeilBrown
