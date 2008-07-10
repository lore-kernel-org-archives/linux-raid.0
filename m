From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Wed, 9 Jul 2008 22:27:36 -0300
Message-ID: <20080710012736.GD15729@khazad-dum.debian.net>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern> <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan> <alpine.LFD.1.10.0807081232350.32659@bbs.intern> <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan> <alpine.LFD.1.10.0807090726200.686@bbs.intern>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807090726200.686@bbs.intern>
Sender: linux-raid-owner@vger.kernel.org
To: Gerhard Wiesinger <lists@wiesinger.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 09 Jul 2008, Gerhard Wiesinger wrote:
> Load on power supply measured on 220V side with a true RMS Wattmeter:

That won't help for the failure mode you're looking for.

Hook an osciloscope to the power lines on the HD's power feed, and try to
get it to trigger on any "big" variations.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
