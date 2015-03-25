From: Scott Sinno <sinno@sinno.net>
Subject: Re: RAID6 won't reassemble after disk controller failure
Date: Wed, 25 Mar 2015 11:29:01 -0400
Message-ID: <5512D43D.1050803@sinno.net>
References: <5512D21E.1010506@sinno.net> <alpine.DEB.2.02.1503251621390.20507@uplift.swm.pp.se> <5512D3AA.5000003@sinno.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5512D3AA.5000003@sinno.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org, "Vaughan, Garrison (GSFC-606.2)[INTERNATIONAL TECHNOLOGY COALITION, INC]" <garrison.r.vaughan@nasa.gov>
List-Id: linux-raid.ids

Scott Sinno wrote:
> It doesn't appear to be very telling.  Note that per the provided
> '-E'(examine) output, event count is off a bit on some of the drives,
> and several report 'missing'

Clarification - the drives themselves are not 'missing', they're healthy
and present, 'mdadm -E' reports some components missing in the 'Array
State' field.

