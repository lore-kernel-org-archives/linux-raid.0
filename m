From: "Chris Fanning" <christopher.fanning@gmail.com>
Subject: Re: not resyncing after power cut.
Date: Tue, 22 May 2007 12:21:47 +0200
Message-ID: <215ff4410705220321l315d7351qcd480fc4d5343abd@mail.gmail.com>
References: <215ff4410705210808g779ba32dhee018f0bd81382d8@mail.gmail.com>
	 <18002.45945.265950.221863@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18002.45945.265950.221863@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> > Can someone shed some light on this for me please?
>
> Sounds like it could be a kernel bug.  What version (exactly) are you
> running?
>

On the test machine I installed yesterday I'm running a stock debian
etch. 2.6.18-4-686. I didn't do anything tricky during the
installation but just simply followed the installation interface
steps.

The machine that gave me the problems is a 2.6.16 686 booting from xen-3.0.2-2
I also have a second 2.6.16 booting from xen-3.0.2-2.
All machines are debian etch.

I've done this on both the 2.6.16 and the 2.6.18.4
Start copying onto the mdadm device and then hit the reset button on the pc.
On boot, everything starts as normal. no resync, nothing.
Both of them.
The 2.6.16 is compiled by me, but the 2.6.18-4 is etch out of the box.

When I shutdown these machines gracefully, I also get
Stopping array md1 (failed, busy)
....
on the arrays that initramfs setup (I think).

Thanks.
Chris.

> NeilBrown
>
