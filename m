From: Terje Kvernes <terjekv@math.uio.no>
Subject: Re: filesystem corruption with RAID6.
Date: Fri, 03 Sep 2004 22:27:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <wxxr7pjumhh.fsf@nommo.uio.no>
References: <wxx7jrbo87d.fsf@nommo.uio.no> <20040903170627.GA11021@jim.sh>
	<4138B5A6.7070304@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4138B5A6.7070304@zytor.com> (H. Peter Anvin's message of "Fri,
 03 Sep 2004 11:19:18 -0700")
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"H. Peter Anvin" <hpa@zytor.com> writes:

  [ ... ]

> Note: the corruption Jim found and which I have confirmed are only
> when doing large number of writes to a filesystem in degraded mode.
> If you see something different, please let me know.  It would
> definitely help tracking this down.

  ah!  that explains it then.  I was indeed copying over data in
  degraded mode.
   
> The bug is elusive enough that it's difficult :-/

  ouch.  and RAID that can't be written to in degraded mode is
  somewhat impractical for production use.  ;-)
 
  is there anything I can do to help?  otherwise, I'll fall back to
  RAID5 and prepare the box for production.

-- 
Terje
