From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian "woody", homebrew 2.4.25
 kernel
Date: Wed, 4 Aug 2004 11:00:09 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408041058470.7382-100000@uplift.swm.pp.se>
References: <ceq7ij$vj7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ceq7ij$vj7$1@sea.gmane.org>
To: Jens Benecke <jens@spamfreemail.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 4 Aug 2004, Jens Benecke wrote:

> The goal is to have as "stress free" a system as possible - i.e. with as
> little manual configuration, and in event of emergencies, as little work to
> do, as possible.

You probably should go for hardware RAID1 instead, this will present the
drive as a single drive to the OS and will handle all failure scenarios, 
you will not be hindered by fixing LILO to boot etc. Yes, it'll cost a bit 
more but if your goal is simplicity and carefree running, this is probably 
the best way.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

