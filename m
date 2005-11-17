From: Neil Brown <neilb@suse.de>
Subject: Re: raidtools-1.00.3-234 bug report
Date: Thu, 17 Nov 2005 23:50:03 +1100
Message-ID: <17276.31867.303492.515360@cse.unsw.edu.au>
References: <BAY107-F3E87D7A3C696C702B75979C5F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from d binderman on Thursday November 17
Sender: linux-raid-owner@vger.kernel.org
To: d binderman <dcb314@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 17, dcb314@hotmail.com wrote:
> 
> Hello there,
> 
> I just tried to compile package raidtools-1.00.3-234 with the Intel C 
> compiler.
> 
> It said
> 
> scsi.c(277): warning #175: subscript out of range
> 
> The source code is
> 
>     sg_dev->revision[5] = '\0';
> 
> but
> 
> ../BUILD/raidtools-1.00.3/scsi.h:    char revision[5];
> 
> Suggest code rework.

<slightly-biased>
 Suggest you don't bother compiling raidtools.  No one is maintaining
 it, fewer and fewer people are using it.
 Suggest use mdadm instead.
</slightly-biased>

NeilBrown
