From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm mail option configuration
Date: Thu, 30 May 2002 09:10:41 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15605.24561.501893.319158@notabene.cse.unsw.edu.au>
References: <15604.45423.781175.499314@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.30.0205291602130.23219-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Danilo Godec on Wednesday May 29
To: Danilo Godec <danci@agenda.si>
Cc: Jeff Hill <jhill@hronline.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 29, danci@agenda.si wrote:
> On Wed, 29 May 2002, Neil Brown wrote:
> 
> > > Then, I just have an init script that runs:
> > >
> > > 	/sbin/mdadm -Fs --delay=600 &
> >
> > Why 600 (10 minutes)?? I would suggest 60seconds for normal operation
> > and 1 second for testing.
> 
> I've tried this and maybe I'm missing something. I've set a 5 second
> interval for checking and I only got one mail - notifiyng me about
> a failure.

Yes, that's right.  One failure, one email.  I'm not in the business
of spam.

> 
> Now I'm not sure whether mdadm is supposed to send mail on every check? Or
> is it sending mail just when a BAD thing happens?

Exactly.

It has occurred to me that it could be useful to send mail at startup
if there appear to be any abnormalities, but I think I would prefer
that sort of functionality to be external.  A sysdamin might want that
mail are reboot, or every night, or every week, or never.  A simple:
  grep -s > /dev/nu $magic_pattern /proc/mdstat && 
       mail -s "Raid problem on `hostname`" root << END
	    Possible RAID problem, please check.
	    `hostname`
	    `cat /proc/mdstat
	    END

is all that is needed.
> 
>   D.
> 
> PS: The PROGRAM was started more often (I think three times).

That's quite possible. 
   Once for  Fail
   Once for  RebuildStarted
   maybe some RebuildNN
   Once for  SpareActive

NeilBrown
