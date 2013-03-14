From: Phil Turmel <philip@turmel.org>
Subject: Re: Missing superblock on one of the raid devices on raid 0 with
 1.2 metadata
Date: Thu, 14 Mar 2013 11:32:47 -0400
Message-ID: <5141ED9F.3060204@turmel.org>
References: <1363271252.29407.20.camel@hanna64.taxback.ess.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363271252.29407.20.camel@hanna64.taxback.ess.ie>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <nkichukov@taxback.com>
Cc: linux-raid@vger.kernel.org, Ivan Yordanov <iyordanov@taxback.com>
List-Id: linux-raid.ids

On 03/14/2013 10:27 AM, Nikolay Kichukov wrote:
> Hi all,
> 
> We are trying to recover a broken raid 0. It consisted of 4 raid
> devices. One of them got the metadata/superblock zeroed and now the raid
> cannot assemble.
> 
> OS: Gentoo Linux
> 
> My colleague will be able to provide more information regarding kernel
> version and mdadm version.
> 
> Is there a way to copy the superblock/metadata from one of the remaining
> drives and edit it prior to placing it on the zeroed drive so that the
> raid can be assembled?
> 
> Any hints and pointers are welcomed. Is it possible to fix the raid in
> the first place? If yes, then how do we locate the superblock/metadata
> that needs to be copied and edited from one of the raid member devices?

Start by showing the output of "mdadm -E /dev/sdX" for all of the other
member devices or partitions.  It's likely to be possible to fix your
problem.

Phil
