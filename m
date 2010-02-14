From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 19:34:00 -0200
Message-ID: <20100214213400.GD15722@khazad-dum.debian.net>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
 <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
 <4B77044B.1020609@zytor.com>
 <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
 <4B7719C1.1060400@zytor.com>
 <4B785C49.7010105@shiftmail.org>
 <4B786898.8030309@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B786898.8030309@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Asdo <asdo@shiftmail.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 14 Feb 2010, H. Peter Anvin wrote:
> IMO it would make sense to support autoassemble for 1.0 superblocks, and
> making them the default.  The purpose would be to get everyone off 0.9.
>  However, *any* default is better than 1.1.

Well, FWIW, I would happily use (and recommend) 1.0 with auto-assemble
(after verifying all the emergency repair toolset in use where I work has
been upgraded to support it) in distros where the bootloader has enough of a
clue to not bork on md-1.0 devices.  Which should be most of the current
crop.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
