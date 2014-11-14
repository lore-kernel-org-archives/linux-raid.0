From: Phil Turmel <philip@turmel.org>
Subject: Re: failed RAID 5 array
Date: Fri, 14 Nov 2014 09:52:47 -0500
Message-ID: <5466173F.2060007@turmel.org>
References: <1415807882.4241.36.camel@lappy.neofreak.org>	 <54653735.90007@turmel.org> <1415971164.4241.38.camel@lappy.neofreak.org>	 <546606D4.5070406@turmel.org> <1415974131.4241.41.camel@lappy.neofreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1415974131.4241.41.camel@lappy.neofreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: DeadManMoving <sequel@neofreak.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Tony,

{Convention on kernel.org is to trim posts & bottom or interleave posts}

On 11/14/2014 09:08 AM, DeadManMoving wrote:
> Hi Phil,
> 
> Unfortunately, that does not work :
> 
> # mdadm --assemble --force /dev/md127 /dev/sd[fhi]
> mdadm: /dev/md127 assembled from 2 drives - not enough to start the
> array.

That's quite surprising.

> I don't think that booting with an alternate boot media will help me out
> as kernel and mdadm software are quite recent :
> 
> # uname -r
> 3.14.14-gentoo
> # mdadm -V
> mdadm - v3.3.1 - 5th June 2014

Indeed.

At this point, I would use --create --assume-clean, along with
"missing".  You have a recent enough mdadm to specify
--data-offset=2048, which you definitely need.  Something like:

mdadm --create /dev/mdX --assume-clean --data-offset=2048 \
	--level=5 --raid-devices=4 --chunk=512 \
	missing /dev/sd{f,i,h}

You should verify the Device Role numbers with mdadm -E again, as your
drive letters have changed from the initial report.  To be absolutely
sure, I suggest you record drive serial numbers for each role #.  Also
note the use of braces instead of square brackets--bash re-orders the
latter, and that would break your array.  For this type of recovery, it
is vital that the devices be listed precisely in device role order,
starting with zero.

After creation, verify that the space before and space after stats for
each device match the original report, before fsck or mount.
(--data-offset controls space before, that plus --size controls space
after.)

Phil
