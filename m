From: Egon Eckert <egon@heaven.industries.cz>
Subject: Re: Couldn't umount on /mnt/md0-device busy???
Date: Sat, 20 Jul 2002 10:32:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020720083204.GA23131@chance.cz>
References: <Pine.LNX.4.33.0207161515560.29547-100000@pandora.is.bizsystems.com> <15668.41627.988382.451061@notabene.cse.unsw.edu.au> <003c01c22db8$57b86590$5701a8c0@bomoon> <3D35BCD6.7030300@cfht.hawaii.edu> <06d001c22def$eaa10510$5701a8c0@bomoon> <009d01c22e54$54d968a0$f6de11cc@black> <073d01c22e7e$299d8020$5701a8c0@bomoon> <20020718174720.GD4712@willow.seitz.com> <000501c22ebd$59bc3b40$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000501c22ebd$59bc3b40$5701a8c0@bomoon>
To: bo <bo@sosnetwork.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> It looks like it got the old mount information from manufacturing test.
> I do not have those connections(users) now.
> 
> How do I remove(erase) those information from lockd?

In Debian, the correct way is to do 'exportfs -r', I think.  See the man
page.  Perhaps you can use the same tool in your distro, in case of
kernel-based nfs.

-- 
Egon Eckert, Heaven Industries, s.r.o.
E-mail: egon@heaven.industries.cz
