From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid0/jbod/lvm, sorta?
Date: Wed, 30 Dec 2009 10:36:26 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912301035170.27231@uplift.swm.pp.se>
References: <20091230000357.GA23485@septictank.raw-sewage.fake> <alpine.DEB.1.10.0912300712090.27231@uplift.swm.pp.se> <4B3B1DFA.3090308@computer.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B3B1DFA.3090308@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 30 Dec 2009, Jan Ceuleers wrote:

> Correct me if I'm wrong, but I think that unionfs only allows writes to 
> the highest-precedence branch. So writes to the store would all end up 
> on one disk.

Since he said he would be ok with symlinks, I interpreted that he'd also 
be ok with moving things around between disks when the disk taking all the 
writes became full.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
