From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 - whole disk vs partitions
Date: Sat, 19 Dec 2015 15:36:14 -0500
Message-ID: <5675BFBE.5060604@turmel.org>
References: <56756AF1.7050005@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56756AF1.7050005@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Steven,

On 12/19/2015 09:34 AM, Steven Haigh wrote:

> I've always used the whole disk for the RAID6 - as from what I
> understand, this gives the best layout for various drives - no matter if
> they're 512 or 4096 byte sectors.
> 
> Is this still the case?

There's no real advantage other than an itty bit of space.  If my case
was too small to have a separate mirror for my OS, I'd make three
partitions on everything for boot, LVM root & etc (raid10), and bulk
storage (raid6).  When I have room for the mirrored OS (boot & LVM), I
use whole disks for the bulk storage.

> I've noticed that my resync speeds on this RAID6 hover around 60Mb/sec -
> which I was expecting to be a bit quicker (although I haven't tested
> speeds on this array for years).

Consider using small chunk sizes for parity raid if there's even the
slightest random access usage.  See the list archives for the past
couple weeks for a long thread on performance.  There's many
optimization possibilities.

Phil

