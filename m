From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 6 reads all remaining chunks in a stripe when a single chunk
 is rewritten
Date: Tue, 17 Dec 2013 08:39:16 -0500
Message-ID: <52B05404.7010806@turmel.org>
References: <52B02A08.4090007@informatik.uni-rostock.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B02A08.4090007@informatik.uni-rostock.de>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/17/2013 05:40 AM, Nikolaus Jeremic wrote:
> Hi,
> 
> I've did some Linux MD RAID 5 and 6 random write performance tests with
> fio 2.1.2 (Flexible I/O tester) under Linux 3.12.4. However, the results
> for RAID 6 show that writes to a single chunk in a stripe (chunk size is
> 64 KB) result in more than 3 reads in case of more than 6 drives (tested
> with 7, 8, and 9 drives) in the array (see fio statistics below). It
> seems like that in the event of updating one data chunk in a stripe, all
> of the remaining data chunks are read.
> 
> By the way, in case of RAID 5 and 5 or more drives, the remaining chunks
> seem not to be read when updating a single chunk in a stripe.

This is not a bug.  When writing to a small part of a stripe, the parity
must be recomputed for the whole stripe, causing MD to read the rest of
the stripe.

However, it is mathematically possible to compute the new parity given
the new data, old data, and the old parity.  This is a simple
computation for raid5 and this shortcut has been implemented.

The similar shortcut computation for raid6 has been discussed, but
no-one has provided a patch.  (It is not so simple.)  I suspect a patch
would be welcome. :-)

HTH,

Phil
