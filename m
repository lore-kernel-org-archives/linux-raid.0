From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Promise SATAII150 TX4 or raidreconf broken - answer
Date: Sun, 18 Sep 2005 19:56:04 +1000
Message-ID: <432D39B4.5020709@eyal.emu.id.au>
References: <430E4AB0.2060600@eyal.emu.id.au> <4313E433.1080602@pobox.com>	<43223709.8090002@eyal.emu.id.au> <x3kfysdq846.fsf@Psilocybe.Update.UU.SE> <4326061D.1020002@eyal.emu.id.au> <432D2BC6.50300@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <432D2BC6.50300@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tyler wrote:
> Eyal Lebedinsky wrote:
> 
>> Executive summary: it is not the TX4. It is not really raidreconf.
>> You must specify the parity-algorithm in raidtab because the
>> raidreconf default is not what one expects.
[trim]

> Nice work Eyal :)
> 
> Now all we need is a patch for raid-reconf to fix default behaviour? :D
> 
> Regards,
> Tyler.

Well, as simple as this looks, I have little understanding of what
goes on here. For example, looking at raidtools-1.00.3, I see this:

This is defined in three source files, as well as in common.h

# define RAID5_ALGORITHM_LEFT_SYMMETRIC        (2)

In prconv.c, readboth.c, rrc_raid5.c and sectors.c the algorithm
hard set:

static unsigned long
raid5_compute_block (... whatever ...)
{
        int algorithm = RAID5_ALGORITHM_LEFT_SYMMETRIC;
	...
	/* Select the parity disk based on the user selected algorithm */
	switch (algorithm) {

I cannot see how 'algorithm' can be altered at all here, so I do not
think that these programs respond to the raidtab algorithm at all.

In short, maybe raidreconf should not only default to left-symmetric
but refuse any other algorithm if it needs to cooperate with the other
programs here.

Better someone who knows this area does this. The actual setting
of a default is simple.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
