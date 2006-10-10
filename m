From: Neil Brown <neilb@suse.de>
Subject: Re: Stopping and starting a RAID1 :Invalid argument
Date: Tue, 10 Oct 2006 12:01:56 +1000
Message-ID: <17706.65300.747341.601657@cse.unsw.edu.au>
References: <d0383f90610080305x4d06d307yfc497f39761f073c@mail.gmail.com>
	<Pine.LNX.4.56.0610081115440.20412@lion.drogon.net>
	<d0383f90610080608x77fbfb80qb1e89fa8840f9d0a@mail.gmail.com>
	<20061008132537.M34804@contactbda.com>
	<d0383f90610090040v2d0ab905ka5d4607037dd6e17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ian Brown on Monday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Ian Brown <ianbrn@gmail.com>
Cc: jim@contactbda.com, Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 9, ianbrn@gmail.com wrote:
> 
> In the kernel log I see:
> "md0: raid array is not clean -- starting background reconstruction"
> 
> 
> What is the meaning of "raid array is not clean" ?

It means md believe there could be an inconsistency in the array.
This typically happens due to an unclean shutdown.
Can you post more complete logs ?  100 lines either side should be
plenty.

NeilBrown
