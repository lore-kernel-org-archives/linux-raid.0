From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 09 Oct 2013 09:46:43 -0500
Message-ID: <l33q8a$da4$1@ger.gmane.org>
References: <20131009123135.GT1779@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131009123135.GT1779@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/09/2013 07:31 AM, Andy Smith wrote:
> Any insights appreciated.

Consider the probable failure mode of an SSD.  An SSD is more likely
than an HDD to (1) die with absolutely no warning and (2) die due to
the pattern of data written to it over its lifetime (and the way those
writes interact with the SSD's controller/firmware).

#2 in particular means that there is potentially a much higher
correlation between the failures of SSDs in an array than there is of
HDDs.  (And #1 means that the consequences will be more catastrophic.)

I would recommend using SSDs with two different types on controllers.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

