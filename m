From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Thu, 03 Aug 2006 08:24:28 +0100
Message-ID: <44D1A4AC.3090302@dgreaves.com>
References: <44C5BA6F.3010404@steeleye.com> <17617.21634.568180.436250@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17617.21634.568180.436250@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>   write-bits-here-to-dirty-them-in-the-bitmap
> 
> is probably (no, definitely) too verbose.
> Any better suggestions?

It's not actually a bitmap is it?
It takes a number or range and *operates* on a bitmap.

so:
 dirty-chunk-in-bitmap

or maybe:
 dirty-bitmap-chunk

David


