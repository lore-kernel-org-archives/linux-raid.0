From: Nix <nix@esperi.org.uk>
Subject: Re: Ooops on read-only raid5 while unmounting as xfs
Date: Wed, 24 Jan 2007 22:23:58 +0000
Message-ID: <87odoogj29.fsf@hades.wkstn.nix>
References: <fd8d0180701180218o66a48176q172b029673c22660@mail.gmail.com>
	<17845.25989.10063.901037@notabene.brown>
	<fd8d0180701230642rd9d35e9y7e1058546254bad4@mail.gmail.com>
	<17846.40996.525616.51618@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17846.40996.525616.51618@notabene.brown> (Neil Brown's message of "23 Jan 2007 23:54:47 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Francois Barre <francois.barre@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23 Jan 2007, Neil Brown said:

> On Tuesday January 23, francois.barre@gmail.com wrote:
>> 
>> My question is then : what prevents the upper layer to open the array
>> read-write, submit a write and make the md code BUG_ON() ?
>
> The theory is that when you tell an md array to become read-only, it
> tells the block layer that it is read-only, and then if some process
> tries to open it read/write, it gets an array.

Um. Do you mean it gets an *error*? ;}

-- 
`The serial comma, however, is correct and proper, and abandoning it will
surely lead to chaos, anarchy, rioting in the streets, the Terrorists
taking over, and possibly the complete collapse of Human Civilization.'
