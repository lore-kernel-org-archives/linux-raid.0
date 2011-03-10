From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Growing a raid array online with different capacity disks
Date: Thu, 10 Mar 2011 13:57:49 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1103101356210.7942@uplift.swm.pp.se>
References: <AANLkTinpcNHZYTnhzv=61e_KAuNHm1j9dp4mQqcKOE_d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinpcNHZYTnhzv=61e_KAuNHm1j9dp4mQqcKOE_d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jimbob palmer <jimbobpalmer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Mar 2011, jimbob palmer wrote:

> i.e. 4x1tb disks, take out 1x1tb replace with 1x3tb disk, array grows
>
> Does mdadm support this?

No.

> I searched the official faq and debian faq for expand and grow and
> didn't find anything.

How do you propose that a 4 drive RAID5 (giving you 3 tb usage) would 
redundantly give you more usable space by swapping out one drive for a 
larger one and still be fully redundant?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
