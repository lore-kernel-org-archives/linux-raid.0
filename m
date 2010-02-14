From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 19:14:13 -0200
Message-ID: <20100214211413.GB15722@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <20100214193406.GA15722@khazad-dum.debian.net>
 <4877c76c1002141207s7bac4275xd12ed75e46a670c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1002141207s7bac4275xd12ed75e46a670c4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 14 Feb 2010, Michael Evans wrote:
> Maybe you'd like a simple, easy to customize initramfs creator.

If the distro doesn't use it (as its default initramfs creator, even), it is
a lot more chance for breakage.  Less testing, and all that...

And if I am deploying a specific kernel in a server, you better believe it
is important enough that all due care will be taken so that it won't need an
initrd to mount the root filesystem to begin with ;-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
