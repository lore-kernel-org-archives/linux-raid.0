From: Neil Brown <neilb@suse.de>
Subject: Re: is it possible to change the UUID of an array?
Date: Mon, 5 Dec 2005 13:56:46 +1100
Message-ID: <17299.44142.935336.812298@cse.unsw.edu.au>
References: <1133552488.24610.18.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Adam Nevins on Friday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Adam Nevins <univac@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 2, univac@comcast.net wrote:
> Hi,
> 
> I had a RAID-1 with two mirrors as my root partition.  I decided to
> fail/remove one of the mirrors prior to upgrading parts of the OS so
> that I'd have a backup just in case things went horribly wrong.  After
> doing the upgrade, I wanted to compare the two mirrors, so I assembled a
> new md with the failed mirror.  So far, so good.
> 
> The problem is that I now have two arrays with the same UUID.  I'm
> assuming that automatic assembly is now broken.  For now, I've changed
> mdadm.conf to specify the physical devices, but what I'd like to do is
> generate a new UUID for one of the mirrors.  I haven't found a way to do
> this without recreating the array.

Not easily, no.  Maybe I could add an
  --update=uuid:1234:5678.....
for mdadm-2.2 ....

NeilBrown
