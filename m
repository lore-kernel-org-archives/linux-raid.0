From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: dean's linux raid wishlist
Date: Mon, 27 Oct 2003 08:33:11 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031027133311.GA23709@ti19.telemetry-investments.com>
References: <Pine.LNX.4.58.0310261730450.20038@twinlark.arctic.org>
Reply-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0310261730450.20038@twinlark.arctic.org>
To: linux-raid@vger.kernel.org
Cc: dean gaudet <dean-list-linux-raid@arctic.org>
List-Id: linux-raid.ids

On Sun, Oct 26, 2003 at 05:31:53PM -0800, dean gaudet wrote:
> logging raid
 
A while ago, Neil posted thoughts on a journal design that grew out
of discussion with Stephen Tweeedie:

http://lwn.net/2002/0523/a/jbd-md.php3

> partially failed disks
> 
>    a common failure mode for a disk is to develop a local read error, a
>    few sectors which are unreadable. presently any such error causes md
>    to mark the disk as faulty and remove it from the raid. there are two
>    unfortunate aspects of this approach:

EVMS offers a "badblock layer", though I agree it would be nice to have
this in the RAID code.  [Of course, the DM folks want to make MD go
away...]

Regards,

	Bill Rugolsky
