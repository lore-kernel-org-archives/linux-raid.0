From: David Greaves <david@dgreaves.com>
Subject: Re: mdadm: what if - crashed OS
Date: Fri, 05 Jan 2007 11:21:40 +0000
Message-ID: <459E34C4.3050206@dgreaves.com>
References: <63442.70.104.60.127.1167978180.squirrel@spinellicreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63442.70.104.60.127.1167978180.squirrel@spinellicreations.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vince@SpinelliCreations.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Assuming you can allow some downtime, get yourself a rescue CD such as 'RIP'

This will let you boot into the machine and run mdadm commands.

You don't mention kernel/mdadm versions so you may want to check they're close
on the rescue CD.

Then try looking at the manpage around --assemble.
In particular you may want to try --scan and --uuid (if your RIP/live
kernel/mdadm support it)

Also check out the examples...

Assuming this is a sane machine and you're not in real disaster recovery mode
with drives pulled in from random boxes then look at using the literal string
"--config=partitions" (see the manpage) to avoid creating an mdadm.conf with the
"DEVICE partitions" line - PITA on live CDs where you just want a command line ;)

If you can manage it, this will give you a nice warm feeling about recovering
from a problem and it's pretty safe - just common sense like making sure the
live CD kernel/mdadm are either up-to-date or match your production system.

HTH

Also:
> I have thought about this, and I can't understand how 'mdadm' decides the
> health of an array.

Each disk/partition used by md has a superblock which contains a unique UUID and
other info, like the number of devices and the raid level. mdadm --scan looks
into each partition for a superblock and notes this data. It can then group all
the superblocks with the same UUID together and, for each group, knowing how
many devices it should have, how many it has and how many it needs it can decide
if the device can safely be assembled.

David
PS Yes, I've done this (too many times!)
