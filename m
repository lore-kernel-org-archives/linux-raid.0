From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Mon, 10 Aug 2015 11:35:13 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1508101132070.11810@uplift.swm.pp.se>
References: <1817382.9YhZ7ff5Yl@balsa> <14110213.gd3e4izigE@nell> <alpine.DEB.2.02.1508080809570.11810@uplift.swm.pp.se> <1526790.RuPxcltSBQ@nell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1526790.RuPxcltSBQ@nell>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 8 Aug 2015, Thomas Fjellstrom wrote:

> I did try that :( It fails to assemble because it only sees sdc as a spare.
> Maybe because I did things with the old mdadm first, and did a --remove? That
> seems to have wiped out the "slot" information (it's -1) so the assemble force
> magic can't figure things out? Just a guess on my part.

Unless someone else has a better idea, I'd say you're right. If you would 
have unplugged the failed drive (so it disappeared completely), it could 
probably have been re-added. So unless you have a copy of the old 
superblock, your only way to proceed now is to use --create --assume-clean 
and get all the parameters right (order, offsets etc). There are lots of 
examples in the mailing list archives of people trying this and some 
actually suceeding.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
