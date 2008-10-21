From: David Greaves <david@dgreaves.com>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 20:39:33 +0100
Message-ID: <48FE2FF5.1080202@dgreaves.com>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com> <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com> <cccedfc60810210605w638ac471xbce0ceb616a0c141@mail.gmail.com> <A20315AE59B5C34585629E258D76A97C025BF0B0@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C025BF0B0@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It is also worth saying that this has wandered way off topic.

The comment about parity rebuild yadda yadda was an aside to the real meat: a
drive replace facility that uses very efficient mirroring for >99.9% of the disk
rebuild and parity for the <0.1% where a read-error occured.

Hmm, it occurs in the event of a highly dodgy failed drive then maybe it could
do >99.9% recovery from parity and in the event of a failure from one of the
remaining drives, it could attempt a read from the dodgy disk.

David Lethe wrote:

> Sorry about rant .. but it got to me finally, where people keep posting
> how S.M.A.R.T. seems
> to be this all-knowing mechanism that tells you what is wrong with the
> disk and/or where the
> bad blocks might be.  It isn't.

No, but I run long self-tests on a weekly basis and when it tells me I have a
bad block I can examine further; attempt a re-write; run another long test and
see if it comes back clean.

David Lethe also wrote:
> As original poster wanted to just use SMART to factor in known bad
> blocks on a rebuild, then you can see that there
> Is no viable option unless you already have a full list of known bad
> blocks.  You have to find bad blocks as you
> just read from them as part of the rebuild for these types of disks).

I did say
 force a re-write of SMART identified badblocks using parity calculated values.
and that was innacurate.

I should have said something like:
  when SMART identifies a bad block then force a re-write using parity
calculated values.

I appreciate that SMART isn't that smart - but it has a lot of value way down
here below the top-end enterprise systems.

David
-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
