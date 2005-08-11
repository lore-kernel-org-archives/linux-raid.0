From: Brent Walsh <blinux_adm@yahoo.com>
Subject: Re: endianness of Linux kernel RAID
Date: Thu, 11 Aug 2005 06:38:11 -0700 (PDT)
Message-ID: <20050811133811.58530.qmail@web35305.mail.mud.yahoo.com>
References: <17144.14273.684705.729233@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17144.14273.684705.729233@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- Neil Brown <neilb@cse.unsw.edu.au> wrote:

> Not really....  The kernel reads the superblocks to
> find out the
> details of the array.  If it cannot read them, it
> won't assemble the
> array.
> 
> Depending on the type of array, you could --build
> the array instead.
> This allows for arrays that deliberately don't have
> superblocks.
> It should work for raid0, might work for linear,
> could work for raid1,
> but no for anything else.
> 
> If you want to try it, send me the --examine output.
> and I'll suggest
> a command.
> 

My array is raid5, so I decided to overwrite the
big-endian superblocks and assemble the array.  Your
patch worked as expected and the array is functioning
properly.  Thanks for the help.

Is there a simple way convert the superblocks back to
big-endian while the drives are connected to the
little-endian machine?

-Brent

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
