From: Neil Brown <neilb@suse.de>
Subject: Re: Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 10:10:35 +1100
Message-ID: <20100218101035.3a104fed@notabene.brown>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	<4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
	<4B77044B.1020609@zytor.com>
	<20100216112708.4a863f86@notabene.brown>
	<4B7A6FA3.5080009@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B7A6FA3.5080009@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Feb 2010 11:12:51 +0100
Giovanni Tessore <giotex@texsoft.it> wrote:

> Neil Brown wrote:
> > When mdadm defaults to 1.0 for a RAID1 it prints a warning to the effect that
> > the array might not be suitable to store '/boot', and requests confirmation.
> >
> > So I assume that the people who are having this problem either do not read,
> > or are using some partitioning tool that runs mdadm under the hood using
> > "--run" to avoid the need for confirmation.  It would be nice to confirm if
> > that was the case, and find out what tool is being used.
> >   
> 
> I created it manually with
> mdadm --create /dev/md0 --metadata=1.0 --level=1 --raid-devices=3 
> /dev/sd[abc]1
> but got no warning or confirmation request (mdadm - v2.6.7.1 - 15th 
> October 2008), I guess due to old version.
> 

No - due to your actions not matching my description.

I said "when mdadm defaults to 1.0", though I should have said 
"...defaults to 1.1".  Sorry about that.
In any case, you didn't let it default to anything, so you presumably know
what you are doing.
And no v2.6.7.1 will never default to 1.1 so it will never give the message.
But v3.1.1 will default to 1.1 and when it does, it will print the message.

NeilBrown


> Regards
> 

