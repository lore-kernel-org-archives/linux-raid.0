From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Re: MD or MDADM bug?
Date: Tue, 06 Sep 2005 08:38:13 +0200
Message-ID: <431D3955.AFFFC57A@ardistech.com>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
		<17176.9057.119383.787644@cse.unsw.edu.au>
		<01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH>
		<17176.13548.477061.774536@cse.unsw.edu.au>
		<001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH>
		<17176.51414.689631.346198@cse.unsw.edu.au>
		<003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
		<17177.7688.922030.788691@cse.unsw.edu.au>
		<43195D20.1070103@dtbb.net>
		<17178.37305.857263.952767@cse.unsw.edu.au>
		<62b0912f05090509457a790e22@mail.gmail.com> <17180.62221.163087.348031@cse.unsw.edu.au>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Molle Bestefich <molle.bestefich@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Thanks for your explanation about the kernel autodetect pitfalls. IMHO having
a form of kernel space autodetect is an important feature in Linux. It allows
you to use a real mirror for the root filessystem. When assambling is done
based on root fs files this feature will be lost and the only alternative would
be hardware RAID again.

> 
> On Monday September 5, molle.bestefich@gmail.com wrote:
> > Neil Brown wrote:
> > > No.
> > > I've never liked kernel autodetect, and while I won't break it, I

<big snip>

> 
> Why is it that people never complain about having to put information
> in /etc/fstab about what to mount, but they cannot cope with having to
> put similar information in /etc/mdadm.conf about what to assemble??
> 
They would when mounting the root would depend on /etc/fstab :)

	Bart
