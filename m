From: Neil Brown <neilb@suse.de>
Subject: Re: Is raid6 reshape (grow) supported?
Date: Mon, 13 Oct 2008 11:26:16 +1100
Message-ID: <18674.38312.968462.374912@notabene.brown>
References: <3eba0080810091953x443f35b1u4911dee427570f6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Matt 'Murph' Finnicum on Thursday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Matt 'Murph' Finnicum <mattfinn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 9, mattfinn@gmail.com wrote:
> Can I add a drive and expand a raid6? I know the feature has been
> available for a while for raid5. I've looked around the internet, and
> can't seem to find any up-to-date advice on this subject. I'm assuming
> I can't grow a raid5 into a raid6.

Yes, you can grow a raid6.
You cannot convert a raid5 to a raid6 yet.  Hopefully soon, but there
are so many distractions.

NeilBrown
