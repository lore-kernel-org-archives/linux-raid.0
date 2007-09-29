From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 17:11:18 -0700 (PDT)
Message-ID: <20070929001118.D0F24102F5B@medulla.enet.sharplabs.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>	<87r6knay66.fsf@informatik.uni-tuebingen.de>	<20070925181618.82F47102162@medulla.enet.sharplabs.com>	<87sl521kqh.fsf@informatik.uni-tuebingen.de>	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com> <87k5qe19p0.fsf@informatik.uni-tuebingen.de> <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com> <46FB7D2A.1050608@ziu.info> <20070927
 221049.19BE21023EB@medulla.enet.sharplabs.com> <46FCB403.5060300@msgid.tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <46FCB403.5060300@msgid.tls.msk.ru> (message from Michael Tokarev
	on Fri, 28 Sep 2007 11:57:55 +0400)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Michael Tokarev writes:
: Dean S. Messing wrote:
: > Michal Soltys writes:
: []
: > :  Rsync is fantastic tool for incremental backups. Everything that didn't 
: > :  change can be hardlinked to previous entry. And time of performing the 
: > :  backup is pretty much neglible. Essentially - you have equivalent of 
: > :  full backups at almost minimal time and space cost possible.
: > 
: > It has been some time since I read the rsync man page.  I see that
: > there is (among the bazillion and one switches) a "--link-dest=DIR"
: > switch which I suppose does what you describe.  I'll have to
: > experiment with this and think things through.  Thanks, Michal.
: 
: I haven't actually read the rsync manpage to this detail, but I
: do use rsync for backups this way, but a bit differently - yet
: more understandable without referring to manpages... ;)
: 
: the procedure is something like this:
: 
:   cd /backups
:   rm -rf tmp/
:   cp -al $yesterday tmp/
:   rsync -r --delete -t ... /filesystem tmp
:   mv tmp $today
: 
: That is, link the previous backup to temp (which takes no space
: except directories), rsync current files to there (rsync will
: break links for changed files), and rename temp to $today.

Very nice.  The breaking of the hardlink is the key.  I wondered about
this when Michal using rsync yesterday.  I just tested the idea. It
does indeed work.

One question: why do you not use "-a" instead of "-r -t"?  It would
seem that one would want to preserve permissions, and group and user
ownerships.  Also, is there a reason to _not_ preserve sym-links
in the backup.  Your script appears to copy the referent.

Dean

P.S.  I think this thread has wandered from the topic of "linux-raid".
      I'm happy to cease and desist if this Off Topic discussion
      offends.
