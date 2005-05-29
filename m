From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: cpu
Date: Sun, 29 May 2005 23:52:35 +0400
Message-ID: <429A1D83.6010901@tls.msk.ru>
References: <5d96567b05052815251f1cd297@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b05052815251f1cd297@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Raz Ben-Jehuda(caro) wrote:
> I was testing linux raid for sometime, I created several test units
> which send read request to the raid using big buffers( 4MB).
> It seems to be that the software raid consumes to much cpu. I reach
> 100% cpu usage just by reading from the raid.
> I used 4 disks raid 0.

Now try to do the same test without raid - I bet it will use
as much CPU as your raid test.  Raid0 requires almost no CPU
resources, unlike improperly set up IDE disks (no DMA is the
first thing to check -- hdparm is your friend).

/mjt
