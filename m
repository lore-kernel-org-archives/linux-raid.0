From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 17:09:51 -0500
Message-ID: <1142114991.27020.9.camel@localhost.localdomain>
References: <1142038562.20484.234.camel@localhost.localdomain>
	 <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>
	 <op.s581hroxcigqcu@apollo13>  <4413011F.30709@h3c.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4413011F.30709@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: PFC <lists@peufeu.com>, "Paul M." <paul@gpmidi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2006-03-11 at 08:55 -0800, Mike Hardy wrote:
> I can think of two things I'd do slightly differently...
> 
> Do a smartctl -t long on each disk before you do anything, to verify
> that you don't have single sector errors on other drives

will this test interfere with normal disk io activity?

> 
> Use ddrescue for better results copying a failing drive

yes, ddrescue will be better here than dd.

> 
> -Mike
> 
> PFC wrote:
> > 
> >>> I have a raid5 array that contain 4 disk and 1 spare disk. now i saw one
> >>> disk have sign of going fail via smart log.
> > 
> > 
> >     Better safe than sorry... replace the failing disk and resync,
> > that's all.
> > 
> >     You might want to do "cat /dev/md# > /dev/null", or "cat /dev/hd? 
> > 
> >> /dev/null" first. This is to be sure there isn't some yet-unseen bad  
> > 
> > sector on some other drive which would screw your resync.
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

