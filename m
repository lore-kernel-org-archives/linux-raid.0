From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Mon, 05 Jan 2015 09:25:55 -0800
Message-ID: <54AAC923.1070501@tigertech.com>
References: <20150104210701.GG4713@deb76.aryehleib.com> <54A9B472.9090905@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54A9B472.9090905@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/4/15 1:45 PM, Wols Lists wrote:

> It's only the other raids that have any error correction ability,
> because they use parity etc to be able to tell which set of data is correct.

In theory, yes, but in practice, they don't -- or do they? I thought
that even if you use RAID 6, md doesn't check all members on each read
request, calculate parities, and mask silent platter-level corruption by
ignoring a member spewing bad bits. It just uses parities to fill in
missing data if a member fails.

Or does it actually do error detection, and I'm confused?

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
