From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: Enhancements and clean to linear RAID
Date: Thu, 21 May 2009 13:47:31 +1000 (EST)
Message-ID: <d56960494de9542f3eb4534e6cfa0619.squirrel@neil.brown.name>
References: <37d33d830905182323x22eec1c8l2a7471668c1a02b3@mail.gmail.com>
    <9a138833b29b54e5d6c1eaa188f27399.squirrel@neil.brown.name>
    <37d33d830905190031u5172af46kccb720343e359d99@mail.gmail.com>
    <37d33d830905190346g4147a114o5f4a53bf64c1ebac@mail.gmail.com>
    <18962.39477.173613.395401@notabene.brown>
    <37d33d830905202015xc7e9c63pe646f7dbbf4dec4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905202015xc7e9c63pe646f7dbbf4dec4d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 21, 2009 1:15 pm, SandeepKsinha wrote:
> Hi Neil,
>
>> I have applied them all (with very minor cleanups) and pushed them to
>> my for-next tree.
>
>
> Can you help me pull out this git tree?
> How can I do this ?

Clone a recent linux kernel tree from somewhere, e.g.
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

then fetch my tree into that

  cd linux-2.6
  git fetch git://neil.brown.name/md

then look at the branches

  git branch -a

and choose one to checkout

But don't try to clone directly from neil.brown.name.  My link
isn't fast enough for that.

NeilBrown

