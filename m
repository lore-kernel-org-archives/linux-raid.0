From: Iustin Pop <iusty@k1024.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 17:07:29 +0200
Message-ID: <20071020150729.GB17431@teal.hq.k1024.org>
References: <18200.49267.763509.924873@stoffel.org> <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan> <18200.53593.687483.120827@stoffel.org> <1192810534.1666.68.camel@firewall.xsintricity.com> <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18202.5687.672431.295590@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 20, 2007 at 10:52:39AM -0400, John Stoffel wrote:
> Michael> Well, I strongly, completely disagree.  You described a
> Michael> real-world situation, and that's unfortunate, BUT: for at
> Michael> least raid1, there ARE cases, pretty valid ones, when one
> Michael> NEEDS to mount the filesystem without bringing up raid.
> Michael> Raid1 allows that.
> 
> Please describe one such case please.

Boot from a raid1 array, such that everything - including the partition
table itself - is mirrored.

iustin
