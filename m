From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm raid1 read performance
Date: Wed, 4 May 2011 10:58:22 +1000
Message-ID: <20110504105822.21e23bc3@notabene.brown>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liam Kurmos <quantum.leaf@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 4 May 2011 01:07:45 +0100 Liam Kurmos <quantum.leaf@gmail.com> wrote:

> Hi,
> 
> I've been testing mdadm (great piece of software btw) however all my
> test show that reading from raid1 is only the same speed as reading
> from a single drive.

Why do you expect RAID1 to be faster?  On a single threaded sequential read
there is not much it can do to go faster than a single device.  Maybe on some
multi-thread random IOs it might.
What sort of tests were you running?

NeilBrown


> 
> Is this a known issue? or is there something seriously wrong with my
> system? i have tried v2.8.1 and v.3.2.1 without difference and several
> benchmarking methods.
> 
> best regards,
> 
> Liam

