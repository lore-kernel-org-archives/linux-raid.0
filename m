From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 3ware + RAID5 + xfs performance
Date: Wed, 27 Jul 2005 20:04:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0507272003380.3636@uplift.swm.pp.se>
References: <Pine.SOL.4.58.0507252110320.2683@titan.cfa.harvard.edu>
 <200507252134.13869.hjm@tacgi.com> <20050727092104.GA6215@ii.uib.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050727092104.GA6215@ii.uib.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jul 2005, Jan-Frode Myklebust wrote:

> On Mon, Jul 25, 2005 at 09:34:13PM -0700, Harry Mangalam wrote:
>> I went thru the same hardware config gymnastics
>
> me too, but for RAID0, so here are my numbers for show-off, since I was

But... RAID0 doesn't have the inherent problem RAID5 has in that it has to 
read in order to write, so it's no surprise it's very fast?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
