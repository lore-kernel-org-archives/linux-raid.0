From: Danilo Godec <danci@agenda.si>
Subject: Re: mdadm mail option configuration
Date: Wed, 29 May 2002 16:04:57 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205291602130.23219-100000@duplo.agenda.si>
References: <15604.45423.781175.499314@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15604.45423.781175.499314@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Jeff Hill <jhill@hronline.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 May 2002, Neil Brown wrote:

> > Then, I just have an init script that runs:
> >
> > 	/sbin/mdadm -Fs --delay=600 &
>
> Why 600 (10 minutes)?? I would suggest 60seconds for normal operation
> and 1 second for testing.

I've tried this and maybe I'm missing something. I've set a 5 second
interval for checking and I only got one mail - notifiyng me about
a failure.

Now I'm not sure whether mdadm is supposed to send mail on every check? Or
is it sending mail just when a BAD thing happens?

  D.

PS: The PROGRAM was started more often (I think three times).


