From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Promise SX6000 is a POS.
Date: Thu, 8 Apr 2004 07:47:50 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404080743340.3213-100000@uplift.swm.pp.se>
References: <40749C58.9040009@ocis.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40749C58.9040009@ocis.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 7 Apr 2004, Jason C. Leach wrote:

> I have a Promise SX6000 w/ 6 WD2000 EIDE drives and 128MB cache. I 

I have lost an JBOD array on this card when power to some of the drives in
the array was accidentally not reconnected after hardware maintenance and
the system booted. I spent 1-2 hours trying to get it working again, no
luck. Linux support is not very good, Promise doesnt provide updated
drivers for later kernels. Promise doesnt seem to want to support this
card at all on Linux(they answered some inital email and I received an
beta driver that worked well, which I then had to distribute to others
here on this list because Promise stopped answering email about it
themselves).

I prefer 3ware every single second of the day, have several 7500 8- and
12- channel cards and they have been working flawlessly. The SX6000 was 
taken out and put in a Windows machine instead.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

