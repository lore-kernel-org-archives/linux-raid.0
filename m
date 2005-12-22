From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid
 Level Migration and Online Capacity Expansion
Date: Thu, 22 Dec 2005 16:29:01 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0512221625480.13179@lajli.gau.hu>
References: <20051222100703.23157.qmail@web52909.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051222100703.23157.qmail@web52909.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rik Herrin <rikherrin@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Thu, 22 Dec 2005, Rik Herrin wrote:

> 	1) OCE: Online Capacity Expansion:  From the latest
> version of mdadm (v2.2), it ssems that there is
> support for it with the -G option.  How well tested is

Well, we use LVM above raid, thins is not a big issue.

> 	3) Performance issues:  I'm currently thinking of

I have some simple test with bonnie++, the sw raid superior to hw raid,
except big-name storage systems.
http://zeus.gau.hu/~lajbi/diskbenchmarks.txt

> 	4) Would anyone recommend a certain hotswap
> enclosure?

We used ibm xseries and sun machines. The hotswap working well, but the
number of drives very limited.

Take a look at http://www.coraid.com : very well scalable, cheap storage.

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!
