From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: failed disks, mapper, and "Invalid argument"
Date: Thu, 21 May 2020 13:00:14 +0100
Message-ID: <5EC66D4E.8070708@youngman.org.uk>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk> <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk> <20200521110139.GW1711@justpickone.org>
 <20200521112421.GK1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200521112421.GK1415@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/05/20 12:24, David T-G wrote:
> Sure enough, there it is.  Yay.
> 
> Now ...  What do I do with the last drive?  Can I put it back in and let
> it catch up, or should it reinitialize and build from scratch?

Can't remember the syntax, but there's a re-add option. If it can find
and replay a log of failed updates, it will bring the drive straight
back in. Otherwise it will rebuild from scratch.

That's probably the safest way - let mdadm choose the best option.

Oh - and when you get your Ironwolves or whatever, read up on the
replace option. Much the safest option.

Cheers,
Wol
