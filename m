From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Thu, 28 Oct 2004 17:49:49 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4181313D.5050905@zytor.com>
References: <cleqh6$ps4$1@terminus.zytor.com> <16764.37392.910080.718564@cse.unsw.edu.au> <20041025062026.GA17502@jim.sh> <16767.6168.695527.234379@cse.unsw.edu.au> <417F30C7.9050308@zytor.com> <20041027060018.GA17085@jim.sh> <418048C1.8030404@zytor.com> <20041028160003.GA3502@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041028160003.GA3502@jim.sh>
To: Jim Paris <jim@jtan.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:
> 
> Another issue:  If I create a 6-disk RAID-6 array ...
> 
> ... with 2 missing, no resync happens.
> ... with 1 missing, no resync happens.  (???)
> ... with 0 missing, resync happens.
> ... with 2 missing, then add 1, recovery happens.
> ... with 0 missing, then fail 1, resync continues.
> 
> Shouldn't resync happen in the created-with-1-disk-missing case?
> 

Nevermind, I guess it probably should, since there is still redundancy 
and therefore it can be inconsistent.

	-hpa

