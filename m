From: Sebastian =?iso-8859-15?Q?Sch=E4fer?= <sarek@uliweb.de>
Subject: Wrong checksumming function chosen
Date: Sun, 22 Sep 2002 15:51:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020922135108.GA1441@uliweb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

It seems as my computer (Athlon XP 2000+) chooses the wrong checksummin=
g
function.

The kernel output is as follows:

raid5: measuring checksumming speed
   8regs     :  2564.000 MB/sec
   32regs    :  2260.000 MB/sec
   pIII_sse  :  4748.400 MB/sec
   pII_mmx   :  3921.200 MB/sec
   p5_mmx    :  5022.400 MB/sec
raid5: using function: pIII_sse (4748.400 MB/sec)

I hope I can help the developers with this piece of information.
And I also hope I mailed at the right address.

Greets,
--=20
Sebastian Sch=E4fer
E-Mail: sarek@uliweb.de || http://www.uliweb.de
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
