From: Danilo Godec <danci@agenda.si>
Subject: Re: mdadm mail option configuration
Date: Thu, 30 May 2002 08:25:26 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205300822230.32285-100000@duplo.agenda.si>
References: <15605.24561.501893.319158@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15605.24561.501893.319158@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 May 2002, Neil Brown wrote:

> > I've tried this and maybe I'm missing something. I've set a 5 second
> > interval for checking and I only got one mail - notifiyng me about
> > a failure.
>
> Yes, that's right.  One failure, one email.  I'm not in the business
> of spam.

I see, I thought it would mail on every status change - as in 'rebuild
started', 'spare active', etc.

> > Now I'm not sure whether mdadm is supposed to send mail on every check? Or
> > is it sending mail just when a BAD thing happens?
>
> Exactly.

OK; that's fine.

> > PS: The PROGRAM was started more often (I think three times).
>
> That's quite possible.
>    Once for  Fail
>    Once for  RebuildStarted
>    maybe some RebuildNN
>    Once for  SpareActive

Yup, that's exactly how it was. :)

Thanks, D.

