From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 11:06:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040801150258.M30882@contactbda.com>
References: <20040730234706.M12321@contactbda.com> <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I understand this, but I need the space.  I have databases that are over 3TB and my customers don't want to pay.  I 
just need to get the biggest bang for my customers bucks.  I know you get what you pay for.  I just didn't expect the 
3ware cards to perform so bad.  I think I would have been better off with 4 SATA controllers in the system and do 
software raid.  For my customers that will pay the big $$$, I am using SCSI raid controllers from ICP (now Intel I 
believe).

I am switching all of my 3ware controllers over to Adaptec SATA raid controllers.  I am getting better performance 
with them.  
Jim




---------- Original Message -----------
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Jim Buttafuoco <jim@contactbda.com>
Cc: linux-raid@vger.kernel.org
Sent: Sat, 31 Jul 2004 10:49:00 +0200 (CEST)
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers

> On Fri, 30 Jul 2004, Jim Buttafuoco wrote:
> 
> > I have a dual XEON 3.2 Ghz system 12 G of ram with a 3ware 8506-8 in it
> > (8 250 G drives).  The hard raid performance was very bad.  with the
> > load avg going over 40.  I then switched over to JBOD and software raid.  
> > The IO wait times are really high and the performance sucks.  Very hard
> > to explain to my boss where the $20k went. The system is a database
> > server (postgres).  I tried both kernel 2.4 and 2.6 with the same
> > problem.  I am now in the process of testing the adaptec raid
> > controller.
> 
> You should never ever ever use raid5 with something that is write 
> intensive, such as a database server. Raid5 is a cost compromise that is a 
> little of everything, if you want protection and speed at the same time, 
> you should use raid1 (and possible raid0 the raid1:s).
> 
> I learnt this the hard way running a nntp (news) server.
> 
> -- 
> Mikael Abrahamsson    email: swmike@swm.pp.se
------- End of Original Message -------

