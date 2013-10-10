From: Phil Turmel <philip@turmel.org>
Subject: Re: Broken array, trying to assemble enough to copy data off
Date: Thu, 10 Oct 2013 13:58:15 -0400
Message-ID: <5256EAB7.9000500@turmel.org>
References: <5255E5E4.8010900@alteeve.ca> <5255E98C.3020009@alteeve.ca> <5256A14B.7030008@turmel.org> <5256D3C4.5010109@alteeve.ca> <5256D773.2010808@turmel.org> <5256DBD4.4030906@alteeve.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5256DBD4.4030906@alteeve.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Digimer <lists@alteeve.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/2013 12:54 PM, Digimer wrote:
>> Phil
> 
> What if I don't have rock-solid knowledge? Is there a way to connect the
> four drives and query them to determine which is which? I was using the
> new system (minus the new drives) plus a spare new 500GB drive with the
> fresh centos install to do the testing yesterday. I am pretty sure I can
> redo the cabling to match, but I always prefer safe over sorry. :)

Your mdadm -E reports clearly identified the order for the device names
at that moment.  You can replug drives and query them again if you like.
 Look for "Device Role :" in the output of "mdadm -E".  The numbering
starts with zero.

> Thanks very much for your help so far!

You are welcome.

Phil

