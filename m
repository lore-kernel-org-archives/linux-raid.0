From: <pg_mh@mh.to.sabi.co.UK>
Subject: Re: raid6 resync blocks the entire system
Date: Sun, 18 Nov 2007 20:49:44 +0000
Message-ID: <18240.42344.102986.988879@base.ty.sabi.co.UK>
References: <fhq60j$an9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
In-Reply-To: <fhq60j$an9$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Sun, 18 Nov 2007 21:06:42 +0100, Bernd Schubert
>>> <bernd-schubert@gmx.de> said:

bernd-schubert> Hi, on raid-initialization or later on a re-sync
bernd-schubert> our systems become unresponsive. [ ... ] Also,
bernd-schubert> the higher the stripe cache size, the higher the
bernd-schubert> probability the system will go into this state.

Is either point surprising?

[ ... ]

bernd-schubert> Any ideas?

Well, the default Linux storage subsystem parameters are set
usually for high throughput, not low latency. Anyhow, there is
another interesting point, which is how many disks in that RAID6
array? What is the system bus and host adapter to the disk bus?
