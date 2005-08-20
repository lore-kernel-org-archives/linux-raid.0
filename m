From: djani22@dynamicweb.hu
Subject: Re: Oops in raid1?
Date: Sat, 20 Aug 2005 18:57:31 +0200
Message-ID: <026c01c5a5a8$467e53a0$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene> <E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au> <009001c58ac8$9ab25d40$0400a8c0@LocalHost> <17114.55335.687696.686786@cse.unsw.edu.au> <03e501c5a120$f3a79a00$0400a8c0@LocalHost> <17151.60931.26972.713074@cse.unsw.edu.au> <011101c5a187$3bc8cf00$0400a8c0@LocalHost> <17156.4079.67097.825741@cse.unsw.edu.au> <007001c5a40b$03f7e3a0$0400a8c0@LocalHost> <017a01c5a56d$63127720$0400a8c0@LocalHost> <1124553238.3810.133.camel@localhost.localdomain> <025a01c5a5a3$ee160540$0400a8c0@LocalHost> <1124556642.3810.143.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message -----
From: "Pallai Roland" <dap@mail.index.hu>
To: <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, August 20, 2005 6:50 PM
Subject: Re: Oops in raid1?


>
> On Sat, 2005-08-20 at 18:26 +0200, djani22@dynamicweb.hu wrote:
> > I get this message, when high upload. (disk write)
> > But the GNBD generates this, in that situation, and thats why I think,
this
> > is something else...
>  yes, seems like it's an another bug in the GNBD, but the backtrace is
> clear in the first case too, the request to the underlying device what's
> generated that panic, not the raid1d's own.

OK, I understand. :-)
In this case, I'll send it to RedHat's list...

>
>  all in all, try to disable the preempt mode, that may help..

Yes, I know it! :-)
The preempt-kernel is much older! :-)

Thanks for help!

Janos

>
>
> --
>  dap

