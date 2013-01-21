From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Chances of silent errors?
Date: Mon, 21 Jan 2013 16:00:17 -0700
Message-ID: <2F4E0D43-D487-4722-B582-1F424B7BFF10@colorremedies.com>
References: <28222077.12.1358798287217.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28222077.12.1358798287217.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 21, 2013, at 12:58 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:

> Hi all
> 
> Coming from the zfs world, I've heard a few talk about the chances of "silent errors", meaning the checksum on the drives match, but the data being bad because of matching checksum (aka collisions). Does anyone in here know the relative chance of something like that happening with the checksums of current harddisks? Is the 1:10^14 or 1:10^15 chances for a URE in regard to this, or is that when the drive reports an error, or those two combined?

It's fun trying to locate what is a URE, a UER, and BER. I don't see even SNIA consistently using one term. WDC uses "Non-recoverable" rather than "unrecoverable" and while linguistically these are the same, if they're effectively using a different term than SNIA it might be a different thing, what is defined as "error". All of these though are disk errors.

SDC is not necessarily a disk only error. It can occur in the disk, in the cable between disk and controller, in the controller, or between controller and memory. So there are actually many more areas where SDC can occur.

To be SDC, it's either undetected error, or it's detected and improperly corrected error. In either case the result is error propagation without the OS being notified by constituent components in the storage stack.

Anyway, I think what you're after, a probability, for ZFS being spoofed as a result of SDC resulting in a checksum collision, is really remote. You're talking about a very rare case of SDC to start out with, second SDC is not well understood to have probabilities, and then you have a remarkably small surface area. To get a collision like you're suggesting, the SDC would have to exactly have affected the data and the metadata in a way that the corrupt data's checksum indicates it's valid data. Both would have to be so affected. That sort of collision is really next to impossible, even for MD5. Collisions have been demonstrated to be possible, but aren't expected in the wild. What checksum method does ZFS default to?

Chris Murphy