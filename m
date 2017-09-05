From: Phil Turmel <philip@turmel.org>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Mon, 4 Sep 2017 23:49:44 -0400
Message-ID: <2e77897c-d111-ed9b-1319-2cc2bddceb76@turmel.org>
References: <20170905003950.6dtfdoxpbadxiibu@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170905003950.6dtfdoxpbadxiibu@merlins.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/04/2017 08:39 PM, Marc MERLIN wrote:
> Howdy,
> 
> I've been seeing a few of these in my logs during a raid check:
> [40320.212151] md6: mismatch sector in range 3581539536-3581539544
> sadly I'm not finding help or documentation on what it really means.

[trim /]

> Given this, what is the suggested course of action?

Do a "repair" scrub (once) instead of a check scrub to fix the parity.
The data blocks themselves (the ones you care about) must be OK since
btrfs is happy.

If future check scrubs keep running into this, investigate if the ranges
reported are all falling on a particular disk, and look for hardware issues.

Phil
