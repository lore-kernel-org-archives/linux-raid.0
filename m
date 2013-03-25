From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID-10 with mixed block size HDDs
Date: Mon, 25 Mar 2013 17:09:00 -0600
Message-ID: <0619B2C8-EEFF-4B58-BF5E-A4ACA7A501AE@colorremedies.com>
References: <20130325180458.GA4833@lazy.lzy>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130325180458.GA4833@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 25, 2013, at 12:04 PM, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
> 
> I've a two disk RAID-10 (far 2, I guess).
> One HDD seems to be going to the HDD heaven,
> so I'm planning to change it.
> 
> The most convenient HDD I found has 4K sectors,
> while the actual ones have 512 byte sectors.

It is a 4Kn drive, or a 512e drive? If it's 512e, as long as you add the whole disk or ensure alignment, it's OK. For 4Kn drives, that may be a problem. But so far I've only seen 4Kn drives as large 3+TB external USB.


Chris Murphy