From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Backups w/ rsync
Date: Sat, 29 Sep 2007 12:43:58 +0400
Message-ID: <46FE104E.3080608@msgid.tls.msk.ru>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>	<87r6knay66.fsf@informatik.uni-tuebingen.de>	<20070925181618.82F47102162@medulla.enet.sharplabs.com>	<87sl521kqh.fsf@informatik.uni-tuebingen.de>	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com> <87k5qe19p0.fsf@informatik.uni-tuebingen.de> <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com> <46FB7D2A.1050608@ziu.info> <20070927
 221049.19BE21023EB@medulla.enet.sharplabs.com> <46FCB403.5060300@msgid.tls.msk.ru> <20070929001118.D0F24102F5B@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070929001118.D0F24102F5B@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean S. Messing wrote:
> Michael Tokarev writes:
[]
> : the procedure is something like this:
> : 
> :   cd /backups
> :   rm -rf tmp/
> :   cp -al $yesterday tmp/
> :   rsync -r --delete -t ... /filesystem tmp
> :   mv tmp $today
> : 
> : That is, link the previous backup to temp (which takes no space
> : except directories), rsync current files to there (rsync will
> : break links for changed files), and rename temp to $today.
> 
> Very nice.  The breaking of the hardlink is the key.  I wondered about
> this when Michal using rsync yesterday.  I just tested the idea. It
> does indeed work.

Well, others in this thread already presented other, simpler ways,
namely using --link-dest rsync option.  I was just too lazy to read
the man page, but I already knew other tools can do the work ;)

> One question: why do you not use "-a" instead of "-r -t"?  It would
> seem that one would want to preserve permissions, and group and user
> ownerships.  Also, is there a reason to _not_ preserve sym-links
> in the backup.  Your script appears to copy the referent.

Note the above -- "SOMETHING like this".  I was typing from memory,
it's not an actual script, just to show an idea.  Sure real script
does more than that, including error checking too.

/mjt
