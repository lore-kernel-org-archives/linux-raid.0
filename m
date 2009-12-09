From: ml-raid@syscall.eu
Subject: Re: Possible bug
Date: Wed, 09 Dec 2009 10:39:20 +0100
Message-ID: <4B1F7048.7080101@syscall.eu>
References: <4B1E5220.8030500@syscall.eu> <20091209125724.2652d413@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091209125724.2652d413@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> This is not a RAID problem - it was a problem with the grsec patches.
> They assume that any atomic variable is used as a counter and should =
not
> overflow.  That is not the case with bd_disk->sync_io.  It is expecte=
d to
> overflow.  So the "PAX: ..." report is a false positive.
>=20
Thank you,
i've reported the bug to the grsec guys.

Regards,
Rapha=EBl
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
