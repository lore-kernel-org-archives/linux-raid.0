From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Is my raid setup speed ok?!
Date: Wed, 19 Nov 2003 13:56:43 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOMEILGOAA.jim@jimtreats.com>
References: <200311190409.hAJ49ZE22796@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200311190409.hAJ49ZE22796@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>, 'James R Bamford' <jim@jimtreats.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Guy [mailto:bugzilla@watkins-home.com]
> Sent: 19 November 2003 04:10
> To: 'James R Bamford'; linux-raid@vger.kernel.org
> Subject: RE: Is my raid setup speed ok?!
>
>
> It may be too late for this re-sync, but in the future do this:
> echo 100000 > /proc/sys/dev/raid/speed_limit_max
>
> The default speed limit is 10000, that's what you are getting.
> So you have reached a software imposed limit, not a hardware limit.
>
>

Thanks.. I wondered about this.. it could really do with being added into
the HOWTO..

Is this fix a do once.. fix everytime.. or something that i have to do each
time i plan to rebuild an array.. (isn't proc deleted every boot!? so
someone has asked me...)

Thanks tho

Jim

