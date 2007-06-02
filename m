From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 6 grow problem
Date: Sun, 3 Jun 2007 07:38:21 +1000
Message-ID: <18017.58189.826699.729848@notabene.brown>
References: <Pine.LNX.4.64.0706021232040.13184@p34.internal.lan>
	<C2879F21.7ED1%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Iain Rauch on Saturday June 2
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday June 2, groups@email.iain.rauch.co.uk wrote:
> > For the critical section part, it may be your syntax..
> > 
> > When I had the problem, Neil showed me the path! :)
> I don't think it is incorrect, before I thought it was supposted to specify
> an actual file so I 'touch'ed one and it says file exists.
> 
> > For your issue, do you have raid5/6 GROW support enabled in the kernel?
> > Also I grew mine I never used the --backup-file option.
> I don't know, how would I find this out? uname -r gives me 2.6.20-15-server.

raid6 reshape wasn't added until 2.6.21.  Before that only raid5 was
supported.
You also need to ensure that CONFIG_MD_RAID5_RESHAPE=y.

NeilBrown
