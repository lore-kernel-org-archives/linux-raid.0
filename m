From: Monty Charlton <monty@fullmonty.org>
Subject: Re: raid 5 out of sync won't mount
Date: Tue, 18 Jun 2002 17:57:26 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020618175726.A941@stan.fullmonty.org>
References: <3D0F4799.5090403@fullmonty.org> <20020618161549.GA17321@colombina.comedia.it> <20020618165638.GA11713@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020618165638.GA11713@unthought.net>; from jakob@unthought.net on Tue, Jun 18, 2002 at 06:56:38PM +0200
To: Jakob Oestergaard <jakob@unthought.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 18, 2002 at 06:56:38PM +0200, Jakob Oestergaard wrote:
> Yes, that is exactly the way to do it.
> 
> If you mark the right disk as failed, everything will succeed and you
> will not lose your data even though mkraid claims that you will.
> 
> If you, however, mark the wrong disk as failed, or forget to mark a
> disk as failed, no amount of magic is going to bring those data back.
> 
> If it is really important data, it might be advisable to do a raw copy
> of the individual partitions to some other machine - just in case. But
> again, if you do it right, there's no problem  ;)

Thanks so much!  That worked great.  fullmonty.org lives again thanks to you guys. :)

Monty


--
Monty Charlton
http://fullMonty.org

