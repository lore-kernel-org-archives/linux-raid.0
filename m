From: Terje Kvernes <terjekv@math.uio.no>
Subject: Re: filesystem corruption with RAID6.
Date: Sun, 05 Sep 2004 14:32:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <wxxr7pguc9o.fsf@nommo.uio.no>
References: <wxx7jrbo87d.fsf@nommo.uio.no> <20040903170627.GA11021@jim.sh>
	<4138B5A6.7070304@zytor.com> <wxxr7pjumhh.fsf@nommo.uio.no>
	<4138DF2D.5040505@zytor.com> <wxx7jr9veoa.fsf@nommo.uio.no>
	<413A8198.8060805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <413A8198.8060805@zytor.com> (H. Peter Anvin's message of "Sat,
 04 Sep 2004 20:01:44 -0700")
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"H. Peter Anvin" <hpa@zytor.com> writes:

  [ ... ]

> Dig into the code and try to figure out what is happening.  My best
> guess at this point is that a block which is dirty isn't getting
> marked as such, and therefore isn't getting correctly written back,
> but it could also be that it tries to reconstruct a block before it
> actually has all the blocks that it needs to do the reconstruction
> correctly.

  ho-hum.  good idea, but with my current knowledge of the RAID-code,
  I'm somewhat doubtful of what I can accomplish.  I'll try to have a
  look though.  again, thanks for all the work on the MD layer.  ;-)

-- 
Terje
