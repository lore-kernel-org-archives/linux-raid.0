From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: data scrubbing
Date: Fri, 29 Jul 2011 12:03:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107291200580.22537@uplift.swm.pp.se>
References: <4E327445.9080404@oldum.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E327445.9080404@oldum.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <hijacker@oldum.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 29 Jul 2011, Nikolay Kichukov wrote:

> For example is it good for raid1 array?

Yes, it's good for all raid levels that have any kind of redundancy. You 
want to read the information on the drives regularily to make sure it can 
still be read, and if it can't, it can be recomputed from parity and 
written.

Otherwise not-often-read data might have an error on one drive, and then 
another drive fails and now when you try to rebuild you don't have this 
data anywhere all of a sudden (RAID1 and RAID5), and you had no idea about 
this.

Scrubbing is good, do it regularily (at least monthly).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
