From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: excessive IO reported by kernel 2.6
Date: Sat, 15 Apr 2006 17:07:25 -0300
Message-ID: <17473.21117.855733.257536@fisica.ufpr.br>
References: <17473.9786.98946.529932@fisica.ufpr.br>
	<Pine.LNX.4.44.0604151305100.21362-100000@coffee.psychology.mcmaster.ca>
	<17473.16155.282365.988334@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17473.16155.282365.988334@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho (carlos@fisica.ufpr.br) wrote on 15 April 2006 15:44:
 >Sorry, forgot to say this...
 >
 >Mark Hahn (hahn@physics.mcmaster.ca) wrote on 15 April 2006 13:06:
 > >> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
 > >> md0              14,46        57,17       104,96   18050544   33136016
 > >> md2              71,53       145,46       519,37   45922192  163968648
 > >> md1               0,05         0,19         0,19      60592      58688
 > >> 
 > >> md0 is /, md1 swap and md2 /home.
 > >> 
 > >> What I find strange is that the Blk_read for md0 is not negligible
 > >> compared to md2; md0 only has bin, console, dev, etc, lib, proc, root,
 > >> sbin, sys and usr. These should be read mostly soon after boot and
 > >
 > >mounted with noatime?

Well, I did what I should have done before bothering you... I
remounted the partition with noatime and nodiratime, and IO dropped to
almost zero. This shows that all that traffic is indeed inode
updating!

Thanks to Mark for pushing me to be less subjective.
