From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 12:50:36 -0700
Message-ID: <C516161F-6B9A-41D8-BFA0-7B6ACF848DB8@colorremedies.com>
References: <11737275.28.1354044453853.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11737275.28.1354044453853.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 27, 2012, at 12:27 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:

> ----- Opprinnelig melding -----
>> On Nov 27, 2012, at 6:05 AM, David Brown <david.brown@hesbynett.no>
>> wrote:
>>> 
>>> It is /undetected/ disk errors that are a problem. Typical figures I
>>> have seen are around 1 in 1e12 4KB blocks - or 1 in 3e16 bits.
>> 
>> Is this with consumer SATA? Or other?
> 
> According to a few studies I've read, the number of silent errors are identical on both consumer SATA drives and SAS drives. It's the density that makes errors, and the platters and disk heads are produced alike.

That's not what I'm reading:

Corruption detected in 8.5% of nearline disks, and 1.9% in enterprise disks.
http://www.pdsi-scidac.org/events/PDSW09/resources/pdsw09_slides13.pdf

In this study it's 0.86% of nearline, and 0.065% of enterprise disks developing checksum mismatches, out of 1.53 million disks.
http://static.usenix.org/event/fast08/tech/full_papers/bairavasundaram/bairavasundaram.pdf

The ratios are the same.


Chris Murphy