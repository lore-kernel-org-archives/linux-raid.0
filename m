From: Stefan Myankov <kotak@poco-loco.org>
Subject: Re: Software RAID-5 attempt to access beyond end of device...
Date: Mon, 8 Dec 2003 19:55:31 +0200 (EET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0312081954550.2502@poco-loco.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mon, 8 Dec 2003, Mark Hahn wrote:

> do they even work correctly as non-raid controllers?

Yes.. They are intended to. I had my linux installed on a single drive on
one of these controllers.


> I'm guessing these are 80G, right?

Nope 160G all of them, sorry for not mentioning it.

>
> I belive there have been bugs like this in reiserfs.  of course,
> you failed to give any hint about which kernel you might be using...
>
> if I were you, I'd immediately upgrade to the latest kernel.org kernel
> (2.4.23), and do some serious testing...
>

The kernel version I use is 2.4.22. Since I'm using slackware linux distro
I suppose it is a kenrel.org kernel. As for the filesystem, this would be
the cause of the problem. I've ran multiple tests with bonnie++,
performance is outstanding - 75mb/s sequential read 60mb/s write, just
until drives fill up with data up to the mentioned point of 30-35%.
As for the 2.4.23 stuff I could do it but I hoped that someone could give
me a hint where might be the problem.
