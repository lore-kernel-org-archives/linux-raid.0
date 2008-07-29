From: Neil Brown <neilb@suse.de>
Subject: Re: cosmetic bug in mdadm
Date: Tue, 29 Jul 2008 13:52:26 +1000
Message-ID: <18574.37882.879252.6383@notabene.brown>
References: <cccedfc60807281035n23a93665s412cab3b25464ef5@mail.gmail.com>
	<18574.28090.931731.900997@notabene.brown>
	<Pine.LNX.4.64.0807281805190.20007@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Monday July 28
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday July 28, babydr@baby-dragons.com wrote:
> > --- a/ReadMe.c
> > +++ b/ReadMe.c
> > @@ -518,9 +518,12 @@ char Help_grow[] =
                              ^^^^^^^^^
> > "  --size=        -z   : Change the active size of devices in an array.\n"
> > "                      : This is useful if all devices have been replaced\n"
> > "                      : with larger devices.\n"
> > -"  --raid-disks=  -n   : Change the number of active devices in an array.\n"
> > +"  --raid-devices= -n  : Change the number of active devices in an array.\n"
> > "                      : array.\n"
>  	To what command  ^^^^^^^^^^^ is this associated in the --help output ?

 mdadm --grow --help

(all the others already spelt it "--raid-devices").

NeilBrown
