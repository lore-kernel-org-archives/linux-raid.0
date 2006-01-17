From: Francois Barre <francois.barre@gmail.com>
Subject: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 10:38:31 +0100
Message-ID: <fd8d0180601170138m6847fb14k@mail.gmail.com>
References: <20060117174531.27739.patches@notabene>
	 <43CCA80B.4020603@tls.msk.ru>
	 <fd8d0180601170121s1e6a55b7o@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601170121s1e6a55b7o@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/1/17, Michael Tokarev <mjt@tls.msk.ru>:
> NeilBrown wrote:
> > Greetings.
> >
> > In line with the principle of "release early", following are 5 patches
> > against md in 2.6.latest which implement reshaping of a raid5 array.
> > By this I mean adding 1 or more drives to the array and then re-laying
> > out all of the data.
>
> Neil, is this online resizing/reshaping really needed?

Congratulations Neil, I was really expecting this feature, and will
test as soon as possible.
IMHO, being able to resize 'online' is really interesting, so I would
thank Neil and Steinar much more than I would blame them, Michael :-p.
Regarding box crash and process interruption, what is the remaining
work to be done to save the process status efficiently, in order to
resume resize process ?
In my case, I would really wish to trust resizing enough to use it on
working env.
May I help you ?

Anyway, the patchset you submitted appeared to me so clearly, neat and
simple, that it looks a piece of cake to make it secure. I know it's
wrong, but you know, you can take it as a congratulation for your code
quality :-p

Regards,

F.-E.B.
