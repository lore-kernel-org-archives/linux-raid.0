From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 code ok with 2TB + ?
Date: Sun, 28 Nov 2004 12:19:10 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411281215310.17548@adsl.a2000.nu>
References: <Pine.LNX.4.61.0411281146490.17548@adsl.a2000.nu>
 <41A9AF2C.5010706@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41A9AF2C.5010706@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Nov 2004, Brad Campbell wrote:

> I hope so, I have been using it on a 2.2TB raid-5 for months now. (I have 
> completely filled the partition and e2fsck it monthly so I would hope any 
> glitches should have surfaced by now)

ok looks ok
when i tried 2.3TB last year it failed within a few days (data written to 
the 2TB+ was written to the first part (0-0.3TB)

btw which filesystem are you using ?
(and which stripesize?)
