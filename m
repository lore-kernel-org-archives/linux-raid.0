From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 14:41:40 -0500
Message-ID: <200501101941.j0AJfm922475@www.watkins-home.com>
References: <200501101940.36167.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101940.36167.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You been doing zero length IOs again? :)

How many zero length IOs can you do in a second?

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten
Sent: Monday, January 10, 2005 1:41 PM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

On Monday 10 January 2005 18:13, Guy wrote:

> I have 4 of these:
> raid5: switching cache buffer size, 4096 --> 1024
>
> And 2 of these:
> raid5: switching cache buffer size, 1024 --> 4096

Another thing that only strikes me now that I'm actually counting them: I
have 
_exactly_ 24 of those messages per minute. At any moment, at any time, idle 
or not. (Although a PVR is never really 'idle', but nevertheless)
(well, not really _every_ time, but out of ten samples nine were 24 and only

one was 36)

And this one may be particularly interesting:

Jan  9 02:47:19 dozer kernel: raid5: switching cache buffer size, 512 -->
4096
Jan  9 02:47:24 dozer kernel: raid5: switching cache buffer size, 0 --> 4096
Jan  9 02:47:24 dozer kernel: raid5: switching cache buffer size, 4096 -->
512

Switching from buffer size 0 ?  Wtf ?

Another thing to note is that my switches are between 4096 and 512, not 
between 4k and 1k as Neil's reply would indicate being normal. But I don't 
consider this bit really important.

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

