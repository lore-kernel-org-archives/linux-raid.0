From: Neil Brown <neilb@suse.de>
Subject: Re: Convert v0.9 superblock
Date: Fri, 1 Aug 2008 13:13:00 +1000
Message-ID: <18578.32572.891292.936426@notabene.brown>
References: <20080730173022.GA6622@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Shane W on Wednesday July 30
Sender: linux-raid-owner@vger.kernel.org
To: Shane W <shane-kernel@csy.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 30, shane-kernel@csy.ca wrote:
> Hey all,
> 
> Can a v0.9 superblock be converted to v1.x without
> recreating a raid5 array?  I realize a metadata rebuild
> might be necessary but I don't want to go through a
> complete recreate if that can be avoided.

Not really.
You could probably manage a 0.90 -> 1.0 conversion if you really
wanted to by doing a --create --assume-clean and setting the --size
correctly, but to convert to 1.1 or 1.2 you need to move all the data.

Why do you want to?

NeilBrown
