From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Accesses to not yet running array
Date: Fri, 23 Aug 2013 21:09:24 +0200
Message-ID: <5217B364.1070704@arcor.de>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>	<20130821090634.413491d8@notabene.brown>	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com> <CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/23/2013 12:00 PM, Francis Moreau wrote:

> [ adding Martin in CC since it seems related to DDF... ]

I reproduced it here. The problem is that mdmon isn't running. Simply
try running "mdmon /dev/md127", and the mount should proceed.

You'd avoid the problem by running "mdadm -IR /dev/sda" in the first place.

@Neil: This is unexpected, I think we need some code to start mdmon if
necessary in Manage_run. I considered coming up with a patch, but you
can do it much quicker, I think.

Martin
