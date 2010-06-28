From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: impact of one slow drive?
Date: Mon, 28 Jun 2010 07:21:23 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1006280719420.8623@uplift.swm.pp.se>
References: <EB9469C209DB064DA15714214B92D5167F23871F0F@34093-MBX-C09.mex07a.mlsrvr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EB9469C209DB064DA15714214B92D5167F23871F0F@34093-MBX-C09.mex07a.mlsrvr.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 27 Jun 2010, David Lethe wrote:

> A patch is to run full media reads often to force remapping of 
> hard-to-read blocks.

It's been discussed here before that this actually doesn't happen (which 
would be nice though), a drive won't re-write or re-map a block even 
though it took seconds to read it.

Do you have any indication that it does and in that case, what do you base 
it on?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
