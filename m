From: David Greaves <david@dgreaves.com>
Subject: Re: Read errors and SMART tests
Date: Sat, 20 Dec 2008 21:46:20 +0000
Message-ID: <494D67AC.3060008@dgreaves.com>
References: <20081220013043.GM1749@cubit> <A20315AE59B5C34585629E258D76A97C031B1B62@34093-C3-EVS3.exchange.rackspace.com> <20081220052244.GN1749@cubit> <A20315AE59B5C34585629E258D76A97C031B1B64@34093-C3-EVS3.exchange.rackspace.com> <20081220090909.GO1749@cubit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081220090909.GO1749@cubit>
Sender: linux-raid-owner@vger.kernel.org
To: Kevin Shanahan <kmshanah@disenchant.net>
Cc: David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kevin Shanahan wrote:
> Of the remaining drives, SMART attributes for /dev/sd[cghijkl] all show:
> 
>   196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
>   197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
> 
> /dev/sde shows:
> 
>   196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
>   197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       3
> 
> /dev/sdf shows:
> 
>   196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       2
>   197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
> 
> Unfortunately the original /dev/sdd isn't currently attached, but I'll
> hook that up on Monday and check. I'd expect to see some high numbers
> there.
> 
>> These errors could be
>> Result of something relatively benign, like unexpected power loss.
> 
> Sorry, are you saying that about the errors from libata layer or just
> the errors from the md layer?

I wouldn't dream of contradicting David and I'm sure you've got nothing to worry
about. What's a few bad blocks between friends anyway :)

I will say that I have had very similar problems.

I used ddrescue to read the area around the block until it read without error,
and then re-wrote it. A subsequent smartctl -tlong /dev/sdX would then show no
errors.

In my experience the bad blocks returned regularly and I became very familiar
indeed with forced rebuilds of arrays, array re-creation and other mdadm
incantations as the errors hit the system.

I will say that I've returned a *lot* of these under RMA (after discussions with
Samsung engineers).

Any drive that returns *fail* for a built-in self-test now gets 1 chance and is
then RMAed.

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
