From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: looking for advice on raid drives upgrade
Date: Wed, 30 Mar 2011 13:10:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1103301309100.1942@uplift.swm.pp.se>
References: <imuu5b$gaf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <imuu5b$gaf$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Vincent Schut <schut@sarvision.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 30 Mar 2011, Vincent Schut wrote:

> - offline the raid, dd(rescue) each 1TB drive onto a new 2TB one, 
> replace drives, put raid online again

This works if you have a superblock version that stores its superblock in 
the beginning, not the end (or if you use a partition). This is the 
safest.

> or:
> - manually replace one drive at a time, and let the raid recover and thus 
> write the data onto the new drive?

If you have a bad block anywhere on the degraded drives, you're going to 
lose data.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
