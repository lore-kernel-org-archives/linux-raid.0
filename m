From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 17:34:06 -0200
Message-ID: <20100214193406.GA15722@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 13 Feb 2010, Michael Evans wrote:
> I remember hearing that 1.x had /no/ plans for kernel level
> auto-detection ever.  That can be accomplished in early-userspace
> leaving the code in the kernel much less complex, and therefore far
> more reliable.

Yes, it is far more reliable kernel side, if only because it doesn't do
anything.

But the userspace reliability is _not_ good.  initrds are a source of
problems the moment things start to go wrong, and that's when they are not
the problem themselves.

And the end result is a system that needs manual intervention to get its
root filesystem back.

In my experience, every time we moved critical codepaths to userspace, we
ended up decreasing the *overall* system reliability.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
