From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: MD or MDADM bug?
Date: Mon, 5 Sep 2005 11:35:17 +0200
Message-ID: <dfh3gl$s2b$1@sea.gmane.org>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH> <17176.2600.694418.472339@cse.unsw.edu.au> <018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH> <17176.4401.418417.56385@cse.unsw.edu.au> <019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH> <17176.7326.892297.381537@cse.unsw.edu.au> <01a101c5afa2$8b3f2060$c100a8c0@NCNF5131FTH> <17176.9057.119383.787644@cse.unsw.edu.au> <01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH> <17176.13548.477061.774536@cse.unsw.edu.au> <001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH> <17176.51414.689631.346198@cse.unsw.edu.au> <003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH> <17177.7688.922030.788691@cse.unsw.edu.au> <43195D20.1070103@dtbb.net> <17178.37305.857263.952767@cse.unsw.edu.au> <Pine.LNX.4.61.0509051119300.32217@desktop.agenda.si>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

danci@agenda.si <danci@agenda.si> wrote:
> On Sun, 4 Sep 2005, Neil Brown wrote:
>> I've never liked kernel autodetect, and while I won't break it, I
>> would like to migrate people away from it.
> How will we use MD for root filesystem? Will we *always* need a tricky 
> initrd with mdadm added?

If you don't (like to) have kernel autodetection, you'll always need
initrd with mdadm or something like that to boot up a MD for the root
fs, yes.


regards
   Mario
-- 
> As Luke Leighton said once on samba-ntdom, "now, what was that about
> rebooting?   that was so long ago, i had to look it up with man -k."

