From: Phil Turmel <philip@turmel.org>
Subject: Re: Stacked array data recovery
Date: Mon, 02 Jul 2012 17:42:09 -0400
Message-ID: <4FF215B1.4070105@turmel.org>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>    <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>    <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>    <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>   <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>   <4FEA1A4F.9090605@hardwarefreak.com>  <1341223955.3407.6.camel@hoferr-desktop.hofer.rummelring>  <4FF18A23.9060806@turmel.org> <1341231520.3449.4.camel@hoferr-desktop.hofer.rummelring>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1341231520.3449.4.camel@hoferr-desktop.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/2012 08:18 AM, Ramon Hofer wrote:
> Ok, thanks!
> I will bring it back.
> 
> I've never had to replace a disk so far. Does it depend on the dealer or
> do the manufacturers replace them already when sectors get reallocated? 

I don't know--I've never had an in-service drive fail while still under
warranty :-)  I did have a DOA replaced once, but I doubt that reflects
the hoops you might have to jump through.  Maybe just send them the
smartctl report?

As a hobbyist and small businessman, I only run my own servers.  I don't
handle the volume of drives necessary to personally know the RMA
departments.

Others around here probably do.

>> Interesting.  This drive claims to support SCTERC.  I was under the
>> impression the EARS drives didn't.  Could you please show the output of
>> "smartctl -l scterc /dev/sdl" ?
> 
> Sure:
> 
> ~# smartctl -l scterc /dev/sdl
> smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen,
> http://smartmontools.sourceforge.net
> 
> Error SMART WRITE LOG does not return COUNT and LBA_LOW register
> Warning: device does not support SCT (Get) Error Recovery Control
> command

Very interesting indeed.  The summary report says it *does* support
SCTERC, but when actually probed, it refuses.  That's just evil.

Thanks for running the query.

Regards,

Phil
