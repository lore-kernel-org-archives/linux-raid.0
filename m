From: Peter Hoeg <peter@hoeg.com>
Subject: Re: Add BBL to existing array
Date: Wed, 27 Aug 2014 20:05:04 +0800
Message-ID: <20140827120504.GE21348@dolores.internal.speartail.com>
References: <20140827090707.GA15857@dolores.internal.speartail.com>
 <20140827192721.57c57c3b@notabene.brown>
 <20140827103213.GE15857@dolores.internal.speartail.com>
 <20140827210700.5a9b3e60@notabene.brown>
 <20140827112908.GF15857@dolores.internal.speartail.com>
 <20140827215206.51e6e37e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140827215206.51e6e37e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

>A bbl exist separately on each component device.
>Try
>   mdadm --examine /dev/sda2
>
>look for
>   Bad Block Log : 512 entries available at offset XXX sectors

Bad Block Log : 512 entries available at offset 81 sectors

You're the man. Thank you so much!

--
Regards,
Peter
