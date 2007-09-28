From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 11:57:55 +0400
Message-ID: <46FCB403.5060300@msgid.tls.msk.ru>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>	<87r6knay66.fsf@informatik.uni-tuebingen.de>	<20070925181618.82F47102162@medulla.enet.sharplabs.com>	<87sl521kqh.fsf@informatik.uni-tuebingen.de>	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com> <87k5qe19p0.fsf@informatik.uni-tuebingen.de> <20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com> <46FB7D2A.1050608@ziu.info> <20070927
 221049.19BE21023EB@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070927221049.19BE21023EB@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean S. Messing wrote:
> Michal Soltys writes:
[]
> :  Rsync is fantastic tool for incremental backups. Everything that didn't 
> :  change can be hardlinked to previous entry. And time of performing the 
> :  backup is pretty much neglible. Essentially - you have equivalent of 
> :  full backups at almost minimal time and space cost possible.
> 
> It has been some time since I read the rsync man page.  I see that
> there is (among the bazillion and one switches) a "--link-dest=DIR"
> switch which I suppose does what you describe.  I'll have to
> experiment with this and think things through.  Thanks, Michal.

I haven't actually read the rsync manpage to this detail, but I
do use rsync for backups this way, but a bit differently - yet
more understandable without referring to manpages... ;)

the procedure is something like this:

  cd /backups
  rm -rf tmp/
  cp -al $yesterday tmp/
  rsync -r --delete -t ... /filesystem tmp
  mv tmp $today

That is, link the previous backup to temp (which takes no space
except directories), rsync current files to there (rsync will
break links for changed files), and rename temp to $today.

/mjt
