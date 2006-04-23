From: Arthur Britto <ahbritto@iat.com>
Subject: Re: Unable to add write-intent bitmap
Date: Sat, 22 Apr 2006 19:48:55 -0700
Message-ID: <1145760535.10042.40.camel@profit>
References: <1145743788.10042.33.camel@profit>
	 <17482.59590.954386.580590@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17482.59590.954386.580590@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2006-04-23 at 12:39 +1000, Neil Brown wrote:
> You should be able to make it work by setting the chunk size
> explicitly to 1024k i.e
>      mdadm -Gb internal --bitmap-chunk=1024 /dev/md0

That worked.

Thanks Neil! =D

-Arthur


