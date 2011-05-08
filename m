From: Luca Berra <bluca@comedia.it>
Subject: Re: wish for Linux MD mirrored raid types
Date: Sun, 8 May 2011 20:14:45 +0200
Message-ID: <20110508181445.GB7629@maude.comedia.it>
References: <20110506071752.GA22063@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110506071752.GA22063@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 06, 2011 at 09:17:52AM +0200, Keld J=F8rn Simonsen wrote:
>I would like linux MD raid10 functionality to be part of the Linux MD
>RAID1 module, and be called raid1. This is in accordance with the
then we need rename the current raid1 functionality to 'mirror'. in
order to avoid further confusion.
besides, current raid10 does not support resizing, so the feature
should be added before ditching 'mirror'

L.

--=20
Luca Berra -- bluca@comedia.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
