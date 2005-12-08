From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 in degraded mode; trying to revive
Date: Fri, 9 Dec 2005 10:53:12 +1100
Message-ID: <17304.51048.987108.105274@cse.unsw.edu.au>
References: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
	<17302.10018.330421.986669@cse.unsw.edu.au>
	<dc164f000512062258r21ebb844w4b59238612635d7f@mail.gmail.com>
	<17303.44330.447062.271960@cse.unsw.edu.au>
	<5d96567b0512072153q3e1b3ed4k3d7439c51abe1e93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Wednesday December 7
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Milo <search.lists@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 7, raziebe@gmail.com wrote:
> Neil,
> could u elaborate on kernel/mdadm version this bug was fixed ?
> i having the same problem myslef.

It was fixed in 2.6.12-rc5

The mddev->queue->unplug function was being set to early in 'run', and
if run failed, it would still be set, so attempted to access the
device for IO could cause a crash.

NeilBrown
