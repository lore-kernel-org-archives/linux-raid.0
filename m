From: "Derek Vadala" <derek@cynicism.com>
Subject: Re: Missing capacity in a RAID 5 array?
Date: Thu, 6 May 2004 10:30:57 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <23941.129.44.35.24.1083853857.squirrel@cynicism.com>
References: <4099D554.808@jmorrow.org>
        <4099D74A.20103@wasp.net.au>
Reply-To: derek@cynicism.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4099D74A.20103@wasp.net.au>
To: linux-raid@vger.kernel.org
Cc: jmorrow@jmorrow.org, brad@wasp.net.au
List-Id: linux-raid.ids

Brad Campbell said:
> On my 2.1TB I told mke2fs not to reserve any space for root as I was
> going to lose about 105MB [GB?].

As you fill up this filesystem, you're going to see decreased performance,
as the reserved space isn't just "insurance" for root processes, it's also
essential for managing fragmentation. This doesn't apply, as much, if you
are just adding new files, without ever modifying or deleting the old
ones, or if you are working with a static file set altogether.




