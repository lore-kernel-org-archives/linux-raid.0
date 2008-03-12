From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: first partition on partitionable RAID-5 array
Date: Wed, 12 Mar 2008 20:02:28 +0000
Message-ID: <18392.14036.389629.561497@tree.ty.sabi.co.uk>
References: <47AC7463.7000502@free.fr>
	<20080208081649.rfx07p98ckcgc0sg@estone.ca>
	<47D7F4F7.3040006@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47D7F4F7.3040006@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Wed, 12 Mar 2008 16:21:27 +0100, Hubert Verstraete
>>> <hubskml@free.fr> said:

[ ... ]

hubskml> Regarding the slow write performance on the first
hubskml> partition of a partitionable RAID-5 array, actually
hubskml> this is not linked with the first partition. This issue
hubskml> happens when the partition does not start on a cylinder,

This is a kind of basic issue for the use of parity RAID, and
has nothing to do (at least directly) with cylinders, or with
first partitions. But it manifests itself also with partitions
that begin on cylinder 1 (often but not necessarily the first)
because of the 63 sector offset, and of course also on logical
partitions (same).

The detailed reasons (RMW and alignment) have also been recently
discussed with graphic examples in a couple of recent threads.

hubskml> This symptom doesn't exist on RAID-1.
hubskml> Does anyone know why ?

Those who have been reading the Linux RAID mailing list know why
:-).
