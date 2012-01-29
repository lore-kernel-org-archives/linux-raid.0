From: Mukund Sivaraman <muks@banu.com>
Subject: Re: RAID-6 recovery questions
Date: Sun, 29 Jan 2012 18:37:40 +0530
Message-ID: <20120129130740.GB4332@misha.banu.com>
References: <20120127081025.GA22388@jurassic>
 <20120127175618.GA3341@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120127175618.GA3341@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Piergiorgio

On Fri, Jan 27, 2012 at 06:56:18PM +0100, Piergiorgio Sartor wrote:
> The check using the sysfs will tell you *only* how many
> blocks have a mismatch, that is, how many times the parity
> is not correct.
> 
> The "raid6check" will tell you which stripe have mismatches
> and, if possible, which HDD is responsible for the mismatches.
> It can happen the parity is fine, but one HDD has problems.
> This is done exploiting the RAID6 double parity and, of
> course, can work only on non-degraded arrays.

Thank you for answering. :)


Kind regards,

Mukund
