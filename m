From: NeilBrown <neilb@suse.de>
Subject: Re: debian software raid1
Date: Wed, 20 Apr 2011 22:40:14 +1000
Message-ID: <20110420224014.173a030a@notabene.brown>
References: <1303215166.2809.8.camel@valio>
	<BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>
	<4DADB24F.2030300@cdf.toronto.edu>
	<20110420085148.12ac0002@notabene.brown>
	<4DAEB55D.1010108@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAEB55D.1010108@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Iordan Iordanov <iordan@cdf.toronto.edu>, Mathias =?ISO-8859-1?B?QnVy?= =?ISO-8859-1?B?6W4=?= <mathias.buren@gmail.com>, b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 20 Apr 2011 12:28:45 +0200 Asdo <asdo@shiftmail.org> wrote:

> On 04/20/11 00:51, NeilBrown wrote:
> > If there was such a deadlock, it would be a serious bug.   I don't believe
> > such a bug exists (but hey - I keep finding bugs in this code, when I'm not
> > busy writing new bugs, so I guess it could crash you machine and kill your
> > cat).
> >
> 
> I am aware that raids 0,1,10 do not copy the buffer so I don't think 
> there is risk of deadlock...
> 
> Raids 456 do copy the buffer... but the destination buffers are 
> preallocated, right?

Correct - destination buffers - when used - are preallocated.

If this were not the case you would get deadlocks in normal usage without
having to wait for suspend/resume to trigger them.

NeilBrown
