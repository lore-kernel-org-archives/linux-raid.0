From: "bo" <bo@sosnetwork.net>
Subject: Re: Invalid argument error on raid5 create
Date: Wed, 10 Jul 2002 16:07:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001d01c22866$90c1cb30$5701a8c0@bomoon>
References: <001f01c22632$ad349580$0200a8c0@gandalf><15657.19046.986108.967800@notabene.cse.unsw.edu.au><00cd01c226db$2f71ddc0$5701a8c0@bomoon> <15658.28183.219550.723620@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

You are right.
I found my kernel image did not configure the RAID 5.

Thanks a lot,

Bo
----- Original Message ----- 
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: "bo" <bo@sosnetwork.net>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, July 08, 2002 10:01 PM
Subject: Re: Invalid argument error on raid5 create


> On Monday July 8, bo@sosnetwork.net wrote:
> > Neil,
> > 
> > I am trying to create the RAID 5 array with
> > 
> > >mdadm -C /dev/md0 -l5 -n6 -x1 -prs /dev/hd[bcdefgh]
> > 
> > However, I am getting the following error message;
> > 
> > >mdadm: RUN_ARRAY failed: Invalid argument
> > 
> ..
> > 
> > Any clue?
> 
> Maybe the raid5 personality isn't loaded into the kernel...
> What does 
>   cat /proc/mdstat
> say?
> Are there any message in
>    dmesg
> after the failure?
> 
> NeilBrown
> 

