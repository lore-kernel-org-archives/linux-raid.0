From: Tom Vier <tmv@comcast.net>
Subject: Re: Raid chunksize...
Date: Wed, 28 May 2003 18:55:46 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030528225546.GD6785@zero>
References: <200305280334.52979.matt@lpbproductions.com>
Reply-To: Tom Vier <tmv@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200305280334.52979.matt@lpbproductions.com>
Content-Disposition: inline
To: Matt <matt@lpbproductions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 28, 2003 at 03:34:49AM -0700, Matt wrote:
> raid-level              0
> chunk-size              4
>
> Both drives are 80 gig .. so the total comes out to 160 gig w/ raid0 .. Now is 
> a chunksize of 4k to small (??), or is it optimal (??). Also I'am curios is 

yes, i definetly think that's too small. try 16, 32, and 64. i'm using 32 w/
reiserfs. the only way to really find the optimal size, is of course to try
different sizes timing what you typically use the drives for.

> there anyway to change the chunksize w/o lossing the raid array and the 
> contents inside that array ? 

nope.

-- 
Tom Vier <tmv@comcast.net>
DSA Key ID 0xE6CB97DA
