From: Phil Turmel <philip@turmel.org>
Subject: Re: Broken array, trying to assemble enough to copy data off
Date: Thu, 10 Oct 2013 08:44:59 -0400
Message-ID: <5256A14B.7030008@turmel.org>
References: <5255E5E4.8010900@alteeve.ca> <5255E98C.3020009@alteeve.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5255E98C.3020009@alteeve.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Digimer <lists@alteeve.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning,

On 10/09/2013 07:41 PM, Digimer wrote:
> I forgot to add the smartctl output;
> 
> /dev/sdb: http://fpaste.org/45627/13813614/
> /dev/sdc: http://fpaste.org/45628/38136150/
> /dev/sdd: http://fpaste.org/45630/36151813/
> /dev/sde: http://fpaste.org/45632/36154613/
> 
> (sorry for the top post, worried this would have gotten lost below)

[You could/should have just trimmed the material below.]

Anyways, excellent report.

According to the mdadm -E data, you should only need to perform a forced
assembly, like so:

mdadm --stop /dev/md1
mdadm --assemble --force /dev/md1 /dev/sd[bcde]2

Your drives all have the same event counts, suggesting that they were
all dieing within milliseconds of each other.  One of them lived long
enough to record the another's failure, but not to bump the event count.
 The dead machine almost certainly suffered a catastrophic hardware failure.

Presuming the forced assembly works, you should plan on tossing these
drives after you get your data... they have dangerously high relocation
counts and cannot be trusted.  (Fairly typical for consumer drives
approaching 30k hours.)

HTH,

Phil
