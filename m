From: "NeilBrown" <neilb@suse.de>
Subject: Re: -G to smaller doesn't move superblock... is there _any_ way to
 shrink?
Date: Sat, 7 Nov 2009 06:14:33 +1100
Message-ID: <4182ad6bf659bcbda858b59fc54aba1a.squirrel@neil.brown.name>
References: <20091106125334.GC6212@Toms.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091106125334.GC6212@Toms.NET>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Arthur Oehser <tom@toms.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, November 6, 2009 11:53 pm, Thomas Arthur Oehser wrote:
>
> So, I thought the logical sequence was:
>
> 	resize2fs <smaller>
> 	mdadm -G -z <smaller>
> 	fdisk <smaller>
>
> ... but ...
>
> the mdadm -G -z <smaller> seems to leave the superblock at the end of the
> partition...
>
> Is there _any_ way to do what I'm trying to do?  I don't see options to
> tell it I want
> the superblock to be at offset X or that the partition is "going to be"
> smaller... and
> I don't see options for switching the superblock format and moving stuff
> around... and
> I'm really not wanting to do --create and cross my fingers that everything
> "just works".

Other than using --create, which isn't much of a risk, the only
way to do what you want is to fail and remove each device
from the array, resize the device, add it back to the array, then
when recovery completes, move on to the next device.

NeilBrown

