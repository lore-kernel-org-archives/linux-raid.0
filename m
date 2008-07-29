From: "Conway S. Smith" <beolach@gmail.com>
Subject: Re: cosmetic bug in mdadm
Date: Tue, 29 Jul 2008 12:02:41 -0600
Message-ID: <20080729120241.6da32aa1@hardcode42.net>
References: <cccedfc60807281035n23a93665s412cab3b25464ef5@mail.gmail.com>
	<18574.28090.931731.900997@notabene.brown>
	<Pine.LNX.4.64.0807281805190.20007@filesrv1.baby-dragons.com>
	<18574.37882.879252.6383@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18574.37882.879252.6383@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 29 Jul 2008 13:52:26 +1000
Neil Brown <neilb@suse.de> wrote:
> On Monday July 28, babydr@baby-dragons.com wrote:
> > > --- a/ReadMe.c
> > > +++ b/ReadMe.c
> > > @@ -518,9 +518,12 @@ char Help_grow[] =
>                               ^^^^^^^^^
> > > "  --size=        -z   : Change the active size of devices in
> > > an array.\n" "                      : This is useful if all
> > > devices have been replaced\n" "                      : with
> > > larger devices.\n" -"  --raid-disks=  -n   : Change the number
> > > of active devices in an array.\n" +"  --raid-devices= -n  :
> > > Change the number of active devices in an array.\n"
> > > "                      : array.\n"
> >  	To what command  ^^^^^^^^^^^ is this associated in the
> > --help output ?
> 
>  mdadm --grow --help
> 
> (all the others already spelt it "--raid-devices").
> 

I think he meant the last line, w/ just ": array.\n".  Is that
associated w/ a different command, or should it be removed since the
previous line already has the word array?


Conway S. Smith
