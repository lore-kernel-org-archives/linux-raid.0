From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: RAID 5 questions
Date: Sat, 31 Jul 2004 20:50:35 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1040731204816.7441A-100000@Maggie.Linux-Consulting.com>
References: <20040801033109.GA23032@jim.sh>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040801033109.GA23032@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sat, 31 Jul 2004, Jim Paris wrote:

> > geometry = 2498/255/63, sectors = 40132503, start = 0
> ..
> > geometry = 39813/16/63, sectors = 40132503, start = 0
> > Is this an issue with software RAID? 

no but it'd be better/faster/easier to put 1 disk per ide cable
	- its $20 or less to get a promise ide controller

	- or if you're brave, to disable the onboard raid 
	in the bios and use its connectors as regular ide

1 disk per ide cable if you can ...

c ya
alvin

