From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Subject: Re: Checking if RAID does work?
Date: Wed, 19 Jan 2005 22:22:01 +0100
Message-ID: <yw1xk6q9xgg6.fsf@ford.inprovide.com>
References: <20050117010355.GH347@unthought.net> <20050119195154.23514.qmail@web60405.mail.yahoo.com>
 <a0s2c2-7i2.ln1@news.it.uc3m.es> <200501192217.29258.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> writes:

> To the OP: Yes, every part of a raid-1 array (but only a raid-1
> array) will / should be mountable and have the same filesystem as
> the array has.  HOWEVER you should never ever mount the array AT THE
> SAME TIME as one of its underlying devices!  Always umount first,
> and only then mount the other.

=46urthermore, never ever mount a raid-1 component alone in read-write
mode.  Modifying the mirrors individually will almost certainly result
in breakage when the array is activated again.

--=20
M=E5ns Rullg=E5rd
mru@inprovide.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
