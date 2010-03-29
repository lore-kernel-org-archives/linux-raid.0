From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: WD20EARS data
Date: Mon, 29 Mar 2010 18:59:36 +0200
Message-ID: <4BB0DC78.5080506@stud.tu-ilmenau.de>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAF8185.9040307@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi @all,

I tested the WD20EARS at work today.  They correctly report NO SCT ERC
ability (unlike WDxxEADS from November 2009 on).  Trying the commands
nevertheless results in "command aborted".

So my recommendation would be: if you need a fast large array and want
to use WD, keep enough redundancy and a cold spare.  (Respectively
because I returned 2 drives to Western Digital today, too.  They had
reallocated and pending sectors >100 and already dropped out of RAIDs.)

Or use Hitachi deskstar HDS722020ALA330 - these can set ERC timeouts and
they cost about the same.  We have sold about 10 times as many Hitachis
compared to WDs, but had about the same amount of defective drives.

All the best,
Stefan
