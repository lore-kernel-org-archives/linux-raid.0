From: Colonel Hell <amritanshu@gmail.com>
Subject: Re: RAID6 Query
Date: Wed, 17 Aug 2005 00:44:52 +0800
Message-ID: <4ecc821305081609443247f5d5@mail.gmail.com>
References: <20050717182650.24540.patches@notabene>
	 <E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
	 <009001c58ac8$9ab25d40$0400a8c0@LocalHost>
	 <17114.55335.687696.686786@cse.unsw.edu.au>
	 <03e501c5a120$f3a79a00$0400a8c0@LocalHost>
	 <17151.60931.26972.713074@cse.unsw.edu.au>
	 <011101c5a187$3bc8cf00$0400a8c0@LocalHost>
	 <016001c5a26a$05ad3e40$0400a8c0@LocalHost>
	 <4ecc821305081607304a7c4da0@mail.gmail.com>
	 <Pine.LNX.4.63.0508160838300.20705@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0508160838300.20705@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean-list-linux-raid@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thanks and sorry for a stupid qry suffering from foot-in-the-mouth disease :P

On 8/16/05, dean gaudet <dean-list-linux-raid@arctic.org> wrote:
> On Tue, 16 Aug 2005, Colonel Hell wrote:
> 
> > I just went thru a couple of papers describing RAID6.
> > I dunno how relevant this discussion grp is for the qry ...but here I go :) ...
> > I couldnt figure out why is P+Q configuration better over P+q' where
> > q' == P. What I mean is instead of calculating a new checksum (thru a
> > lot of GF theory etc) just store the parity block (P)again. In this
> > case as well we have the same amount of fault tolerance or not
> > :-s  ...
> 
> this is no better than raid5 at surviving a two disk failure.  i.e.
> consider the case of two data blocks missing -- you can't reconstruct if
> all you have is parity.
> 
> -dean
>
