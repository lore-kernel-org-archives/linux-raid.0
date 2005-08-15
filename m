From: Jon Lewis <jlewis@lewis.org>
Subject: Re: confused raid1
Date: Mon, 15 Aug 2005 12:01:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0508151201150.10349@soloth.lewis.org>
References: <Pine.LNX.4.61.0508151131020.10349@soloth.lewis.org>
 <ddqdtv$3m1$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ddqdtv$3m1$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Aug 2005, Mario 'BitKoenig' Holbe wrote:

> Well, reading the kernel boot messages could help.
> Perhaps, the hdc1 partition is type fd (raid autodetect) and the driver
> for hd[eg] is not in place when the RAID Autodetection is running.

I should have included that.  All 3 of them are type fd.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                | 
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
