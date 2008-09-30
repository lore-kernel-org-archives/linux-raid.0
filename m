From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid1 on HDD + RAM ?
Date: Tue, 30 Sep 2008 21:36:17 +0200
Message-ID: <20080930213617.0da1f315@szpak>
References: <20080930174926.5fdad7f1@szpak>
	<20080930182129.GA28669@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080930182129.GA28669@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill said:     (by the date of Tue, 30 Sep 2008 19:21:29 +0100)

> I don't see why it wouldn't be possible.  I would think you'd get the
> same performance leaving the RAM for caching though - that way anything
> you _are_ actually reading/writing will be cached and the RAM is still
> available for applications if needed.


yes, I know. But in my case this won't work. This data which I want
quickly is seldom accessed therefore it will not be cached.


-- 
Janek Kozicki                                                         |
