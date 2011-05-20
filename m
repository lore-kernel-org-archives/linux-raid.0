From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: why should I "initialize" JBOD disks?
Date: Fri, 20 May 2011 15:32:44 +0200
Message-ID: <20110520133244.GA13330@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just installed an Adaptec SAS 4805 and plugged 8 disks previously used
"as is" (no raid) on an LSI adapter but none are recongnized as boot
disk ("no bios installed").

It seems I need to "initialize" (read: wipe) them in the Adaptec bios
menu before being able to use them as JBOD.

What the fuck?!

By my defintion JBOD should means "just get out of the way and let me
use my disks as they are".

Does that "initlialization" mean that disks become unusable when plugged
to an adapter of any other brand or model?

What is the underlying format of JBOD disks. Can they be read by a
straight, non-raid adapter?

These hardware raid cards suck on so many levels...

</rant>
