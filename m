From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: GPT on MD raid
Date: Mon, 18 Apr 2011 18:55:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104181854380.14027@uplift.swm.pp.se>
References: <iohnsc$ggc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iohnsc$ggc$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 18 Apr 2011, Jeremy Sanders wrote:

> Should I ditch this idea and delve into the complexities of LVM?

Yes. LVM isn't all that complex and a lot more flexible, plus you can do 
"everything" online without having to unmount filesystems to re-partition.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
