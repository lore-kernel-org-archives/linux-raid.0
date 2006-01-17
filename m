From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 11:17:15 +0300
Message-ID: <43CCA80B.4020603@tls.msk.ru>
References: <20060117174531.27739.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932314AbWAQIRV@vger.kernel.org>
In-Reply-To: <20060117174531.27739.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

NeilBrown wrote:
> Greetings.
> 
> In line with the principle of "release early", following are 5 patches
> against md in 2.6.latest which implement reshaping of a raid5 array.
> By this I mean adding 1 or more drives to the array and then re-laying
> out all of the data.

Neil, is this online resizing/reshaping really needed?  I understand
all those words means alot for marketing persons - zero downtime,
online resizing etc, but it is much safer and easier to do that stuff
'offline', on an inactive array, like raidreconf does - safer, easier,
faster, and one have more possibilities for more complex changes.  It
isn't like you want to add/remove drives to/from your arrays every day...
Alot of good hw raid cards are unable to perform such reshaping too.

/mjt
