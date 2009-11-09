From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 9 Nov 2009 17:51:46 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>  <4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Nov 2009, Jon Nelson wrote:

> I've been using 1.1 for everything.  What's the current wisdom
> regarding 1.0 vs 1.1 or 1.2?
> I used 1.1 because that's also where filesystem metadata usually goes
> and therefore one might hope that the presence of the md metadata
> would prevent accidental identification of a raid volume as containing
> a filesystem.

I like 1.2 because if you happen to write an MBR or something to the 
drive, you don't lose the superblock.

With 1.2 I can also take the drive from a 3ware hw-raid (single drive in 
3ware bios) and put in a non-3ware (because the 3ware stores the 
superblock at the end, so when you put it in a non-3ware the end has now 
changed).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
