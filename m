From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Raid1: sdb has a lot mor work then sda
Date: Tue, 24 Apr 2012 12:03:26 -0300
Message-ID: <CABYL=TowjMAef3GtjutvpHs=UqgJBQ_VDZir3L9OqK116vsDSw@mail.gmail.com>
References: <4F96BCC9.9080003@marco.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F96BCC9.9080003@marco.de>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Spannbauer <ds@marco.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it=B4s a read, a write, or both operation?
about load i think it=B4s a very big read (sdb) with a very low write (=
sda)
the disk balance on raid1 is based on nearest (current position - next
read position) disk
on a sequencial read only one disk is better used

i checked that raid1 'have this problem' but it=B4s a hardware limit, i
didn=B4t found a solution yet , maybe others friends can found
i made some read balance method some time ago, and the results is
constant 1% of performace improvement on mixed read/write scenario,
but i didn=B4t saw it as a good performace improvement since it must
have many parameters to configure (time of disk seeks), and the load
isn=B4t proportional, sometimes a disk use is very bigger than the othe=
r
disk

saw raid1 as a parallel/secure work, not as a performace tweak

--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
