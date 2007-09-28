From: Michal Soltys <nozo@ziu.info>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 13:18:09 +0200
Message-ID: <46FCE2F1.4000902@ziu.info>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709182004210.13217@p34.internal.lan>	<20070919014919.DF19D10215F@medulla.enet.sharplabs.com>	<Pine.LNX.4.64.0709190437050.4411@p34.internal.lan>	<20070919174956.9497310209D@medulla.enet.sharplabs.com>	<46F292E2.1090700@tmr.com>	<20070920184738.441FD10208C@medulla.enet.sharplabs.com>	<46F2E159.9030806@msgid.tls.msk.ru>	<20070921005851.44E8910236D@medulla.enet.sharplabs.com>	<87r6knay66.fsf@informatik.uni-tuebingen.de>	<20070925181618.82F47102162@medulla.enet.sharplabs.com>	<87sl521kqh.fsf@informatik.uni-tuebingen.de>	<20070925235016.02F6E1023B9@medulla.enet.sharplabs.com>	<87k5qe19p0.fsf@informatik.uni-tuebingen.de>	<20070927062317.3CCAB1023E0@medulla.enet.sharplabs.com>	<46FB7D2A.1050608@ziu.info>	<20070927
 221049.19BE21023EB@medulla.enet.sharplabs.com>	<46FCB403.5060300@msgid.tls.msk.ru> <87zlz75bsm.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zlz75bsm.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> 
> I was thinking Michal Soltys ment it this way. You can probably
> replace the cp invocation with an rsync one but that hardly changes
> things.
> 
> I don't think you can do this in a single rsync call. Please correct
> me if I'm wrong.
> 

something along this way:

rsync <other options> --link-dest /backup/2007-01-01/ \
rsync://user@server/module /backup/2007-01-02/

It will create backup of .../module in ...-02 hardlinking to ...-01 (if 
possible).

So, no need for cp -l. There's similar example in rsync man. Also - 
multiple --link-dest are supported too.

