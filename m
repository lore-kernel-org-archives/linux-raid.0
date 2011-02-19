From: NeilBrown <neilb@suse.de>
Subject: Re: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive
 array
Date: Sat, 19 Feb 2011 14:59:53 +1100
Message-ID: <20110219145953.24fb31f0@notabene.brown>
References: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larry Schwerzler <larry@schwerzler.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 18 Feb 2011 12:55:05 -0800 Larry Schwerzler <larry@schwerzler.com>
wrote:

> 2. One problem I'm having with my current setup is the esata cables
> have been knocked loose which effectively drops 4 of my drives. I'd
> really like to be able to survive this type of sudden drive loss. if
> my drives are /dev/sd[abcdefgh] and abcd are on one esata channel
> while efgh are on the other is there what drive order should I create
> the array with? I'd guess /dev/sd[aebfcgdh] would that give me
> survivability if one of my esata channels went dark?

Yes, in md/raid10 the multiple copies are an 'adjacent' devices (in the
sequence given to --create).

Of course, you wouldn't actually use the string  /dev/sd[aebfcgdh]
as that expands matches in alphabetical order.:


$ echo  /dev/sd[aebfcgdh]
/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh

Instead use this:

$ echo /dev/sd{a,e,b,f,c,g,d,h}
/dev/sda /dev/sde /dev/sdb /dev/sdf /dev/sdc /dev/sdg /dev/sdd /dev/sdh

NeilBrown
