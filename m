From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 12:22:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107271218380.26694@uplift.swm.pp.se>
References: <20110727141652.7511fc51@notabene.brown> <20110727062110.GA9801@www5.open-std.org> <20110727164959.3352c5a3@notabene.brown> <20110727081729.GA12505@www5.open-std.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110727081729.GA12505@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jul 2011, keld@keldix.com wrote:

> So because of the sometimes low number of intrinsic disk reserve blocks, 
> there would be a point in having this facility replicated in the md 
> layer.

I don't agree at all. I remember back in the old MFM/RLL drive days and I 
don't want to go back there. If a drive has filled up its bad block 
reloaction area with relocated blocks, then it's time to RMA that drive 
and get a new one. It's obviously defective.

The added complexity the bad block scheme you propose would add to the 
code base is worrysome, I'd rather just go with what Neil has suggested so 
far. The hot-replace functionality is a really really needed feature and I 
imagine it can be done much more cleanly without having to duplicate the 
bad block reallocation functionality the drives already have.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
