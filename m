From: Phil Turmel <philip@turmel.org>
Subject: Re: Recreating RAID-5 after SATA controller failure and botched
 auto-assemble
Date: Sun, 27 Dec 2015 18:11:26 -0500
Message-ID: <5680701E.1050808@turmel.org>
References: <20151223105827.55498cb1@narfi.yggdrasil.draxit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151223105827.55498cb1@narfi.yggdrasil.draxit.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Draxinger <wdraxinger.maillist@draxit.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/23/2015 04:58 AM, Wolfgang Draxinger wrote:

> Anyway, I'd appreciate if anyone knew how I could read-only assemble
> the disks into an array that resembles the 42e59462... configuration to
> see if I can pull anything useful from it. There are a few things on
> it (hopefully left) that I'd like to extract, if possible.

I think it's gone.  You only have two members of the 42e59462 uuid
array, and you need at least three.  The others all have 2008 timestamps
so could not have been part of the desired array at any recent date.

Sorry.

You *could* assemble the other array, though, to see what's there:

mdadm -Afv /dev/mdX /dev/sdb1 /dev/sdb4 /dev/sdd

With the failure mode you described, I doubt the series of rebuilds
would have destroyed much.

Phil
