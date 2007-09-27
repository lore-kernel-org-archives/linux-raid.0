From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Backups w/ rsync (was: Help: very slow software RAID 5.)
Date: Thu, 27 Sep 2007 15:10:49 -0700 (PDT)
Message-ID: <20070927221049.19BE21023EB@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>	<87r6knay66.fsf@informatik.uni-tuebingen.de>	<20070925181618.82F47102162@medulla.enet.sharplabs.com>	<87sl521kqh.fsf@informatik.uni-tuebingen.de>	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com> <87k5qe19p0.fsf@informatik.uni-tuebingen.de> <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com> <46FB7D2A.1050608@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <46FB7D2A.1050608@ziu.info> (message from Michal Soltys on Thu,
	27 Sep 2007 11:51:38 +0200)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Michal Soltys writes:
:  Dean S. Messing wrote:
:  > 
:  > I don't see how one would do incrementals.  My backup system uses
:  > currently does a monthly full backup,   a weekly level  3  (which
:  > saves everything that has changed since the last level 3 a week ago) and
:  > daily level 5's (which save everything that changed today).
:  > 
:  
:  Rsync is fantastic tool for incremental backups. Everything that didn't 
:  change can be hardlinked to previous entry. And time of performing the 
:  backup is pretty much neglible. Essentially - you have equivalent of 
:  full backups at almost minimal time and space cost possible.

It has been some time since I read the rsync man page.  I see that
there is (among the bazillion and one switches) a "--link-dest=DIR"
switch which I suppose does what you describe.  I'll have to
experiment with this and think things through.  Thanks, Michal.

Dean

P.S. I changed the Subject: to reflect the new subject. Not sure if
that starts a new thread or not.
