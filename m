From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Got raid10 assembled wrong - how to fix?
Date: Wed, 13 Feb 2008 12:16:47 +0300
Message-ID: <47B2B57F.6000800@msgid.tls.msk.ru>
References: <20080212165900.15511.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080212165900.15511.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

George Spelvin wrote:
> I just discovered (the hard way, sigh, but not too much data loss) that a
> 4-drive RAID 10 array had the mirroring set up incorrectly.
> 
> Given 4 drvies A, B, C and D, I had intended to mirror A<->C and B<->D,
> so that I could split the mirror and run on either (A,B) or (C,D).
> 
> However, it turns out that the mirror pairs are A<->B and C<->D.  So
> pulling both A and B off-line results in a non-functional array.
> 
> So basically what I need to do is to decommission B and C, and rebuild
> the array with them swapped: A, C, B, D.
> 
> Can someone tell me if the following incantation is correct?
> 
> mdadm /dev/mdX -f /dev/B -r /dev/B
> mdadm /dev/mdX -f /dev/C -r /dev/C
> mdadm --zero-superblock /dev/B
> mdadm --zero-superblock /dev/C
> mdadm /dev/mdX -a /dev/C
> mdadm /dev/mdX -a /dev/B

That should work.

But I think you'd better just physically swap the drives instead -
this way, no rebuilding the array will be necessary, and your data
will be safe all the time.

/mjt
