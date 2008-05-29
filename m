From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Thu, 29 May 2008 12:22:23 +0100
Message-ID: <20080529122223.462bf396@core>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
	<20080528195752.0cdcbc6d@core>
	<483DE40D.8090608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483DE40D.8090608@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jens =?UTF-8?B?QsOkY2ttYW4=?= <jens.backman@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

> I really don't think that's any part of the issue, the same memory and 
> bridge went 4-5x faster in other read cases. The truth is that the 
> raid-1 performance is really bad, and it's the code causing it AFAIK. If 
> you track the actual io it seems to read one drive at a time, in order, 
> without overlap.

Make sure the readahead is set to be a fair bit over the stripe size if
you are doing bulk data tests for a single file. (Or indeed in the real
world for that specific case ;))

