From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Raidtools-1.00.3
Date: Wed, 12 May 2004 22:39:52 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c7u93o$3ds$1@terminus.zytor.com>
References: <4098E2D8.7070007@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <4098E2D8.7070007@wasp.net.au>
By author:    Brad Campbell <brad@wasp.net.au>
In newsgroup: linux.dev.raid
> 
> I'm just wondering as raidreconf relies pretty heavily at the moment on some of the raidtools 
> infrastructure and I'm wondering what to do long term.
> I have added raid-6 support to raidtools and updated it to work with kernel 2.6 and LBD, but if the 
> long term plan is to let it bitrot then perhaps I'd be better looking at migrating raidreconf to 
> some other framework and try to make it use mdadm for the low level stuff.
> 
> Ideas or suggestions?
> 

Getting raidreconf into mdadm would be a very good thing, I think.

	-hpa
