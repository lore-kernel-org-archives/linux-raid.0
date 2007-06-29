From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: Does "--write-behind=" have to be done at create time?
Date: Sat, 30 Jun 2007 00:58:59 +0930
Message-ID: <1183130939.4544.6.camel@sibyl.beware.dropbear.id.au>
References: <1183038727.3792.9.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1183038727.3792.9.camel@sibyl.beware.dropbear.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2007-06-28 at 23:22 +0930, Ian Dall wrote:
> I was wanting to try out the "--write-behind" option. I have a raid1
> with bitmaps and write-mostly enabled, which are all the pre-requisites,
> I think.
> 
> It would be nice if you could tweak this parameter on a live array, but
> failing that, it is hard to see why it couldn't be done at assemble
> time. mdadm wont let me though.
> 
> Is this a fundamental limitation?

Looking through the mdadm source code it seems like


		case O(BUILD, WriteBehind):
		case O(CREATE, WriteBehind): /* write-behind mode */

could be changed to 

		case O(GROW, WriteBehind):
		case O(BUILD, WriteBehind):
		case O(CREATE, WriteBehind): /* write-behind mode */

and everything would be OK. I am completely new to this code though, so
I am I missing something?

If you already had a bitmap you would need to remove it first
(--bitmap=none) and then grow it back with writebehind set.

Ian

-- 
Ian Dall <ian@beware.dropbear.id.au>
