From: danci@agenda.si
Subject: Re: MD or MDADM bug?
Date: Mon, 5 Sep 2005 11:20:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509051119300.32217@desktop.agenda.si>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
 <17176.2600.694418.472339@cse.unsw.edu.au> <018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH>
 <17176.4401.418417.56385@cse.unsw.edu.au> <019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH>
 <17176.7326.892297.381537@cse.unsw.edu.au> <01a101c5afa2$8b3f2060$c100a8c0@NCNF5131FTH>
 <17176.9057.119383.787644@cse.unsw.edu.au> <01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH>
 <17176.13548.477061.774536@cse.unsw.edu.au> <001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH>
 <17176.51414.689631.346198@cse.unsw.edu.au> <003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
 <17177.7688.922030.788691@cse.unsw.edu.au> <43195D20.1070103@dtbb.net>
 <17178.37305.857263.952767@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17178.37305.857263.952767@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 4 Sep 2005, Neil Brown wrote:

> No.
> I've never liked kernel autodetect, and while I won't break it, I
> would like to migrate people away from it.
> 
> What will, very likely, be implemented is something in 'mdadm' which
> automatically detects and assembles md arrays.

How will we use MD for root filesystem? Will we *always* need a tricky 
initrd with mdadm added?

 D.

