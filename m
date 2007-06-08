From: Neil Brown <neilb@suse.de>
Subject: Re: Help on Recovering a Corrupted raid5 Partition
Date: Sat, 9 Jun 2007 07:47:26 +1000
Message-ID: <18025.52846.187895.423902@notabene.brown>
References: <11032621.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from phyros on Friday June 8
Sender: linux-raid-owner@vger.kernel.org
To: phyros <dlopuch@mit.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


mdadm --examine
only makes sense on a component of an md/raid array, not on the whole
array itself.  So the "mdadm --examine" errors you were getting were
user errors :-)

Everything looks fine except for the "total devices" "working devices"
"active devices" totals, and they aren't used much.  You can probably
fix them with:

  mdadm --stop /dev/md1
  mdadm --assemble /dev/md1 --update=summaries /dev/sd[abcd]3

but before you do that:
  Why do you say the raid5 partition is corrupted?  What are the
  symptoms that caused you to start looking into this?

NeilBrown
