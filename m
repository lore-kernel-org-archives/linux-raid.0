From: "David Rees" <dbr@greenhydrant.com>
Subject: Re: experiences with 3Ware 6400 3W-6400?
Date: Fri, 27 Jun 2003 11:21:10 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3835.208.48.139.163.1056738070.squirrel@www.greenhydrant.com>
References: <Pine.LNX.4.55.0306261656520.6883@datavibe.net><Pine.LNX.4.55.03062616
         56520.6883@datavibe.net>      
     <5.1.1.6.2.20030626174603.03bacec0@mail.harddata.com><1908.66.75.244.6
     9.1056697569.squirrel@www.greenhydrant.com>
     <Pine.LNX.4.55.0306270920010.6883@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0306270920010.6883@datavibe.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rev. Jeffrey Paul said:
>
> I'd done some quick searches for "3ware" on ebay, having heard good things
> about their ide-raid cards.  The 7xxx series are too expensive for the
> project I'm working on at the moment.  It's either an older card, or
> software RAID1 (and, with all due respect, I don't want to use linux
> software raid in -this sort- of production environment).
>
> Are the 6xxx series really that bad?  I don't care about 'nearly'
> unsupported, just as long as it works.  My budget for this whole project
> is likely less than $500.
>
> We're currently looking at raid1 across two 80-120GB disks for a samba
> file server in an office that does a lot of graphic design.

For that type of usage, the 6xxx series will work out just fine.  There's
nothing wrong with them in RAID 1, 0 or 10.  Just their RAID 5 performance
is a bit lacking.

Looks like you can find them for about $60 these days so they're a good
deal.  Although you can find a 72xx card for about $15-20 more as well.

-Dave
