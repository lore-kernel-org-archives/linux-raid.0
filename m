From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 15:46:54 +0100
Message-ID: <bb145bd20803020646u6db82c3em375ae477e0f1bbb3@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <20080302134836.GB20333@cthulhu.home.robinhill.me.uk>
	 <bb145bd20803020617i77113488h53ead5af3b10e48@mail.gmail.com>
	 <20080302153236.36981345@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080302153236.36981345@absurd>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  > OS:
>  > Debian testing-amd64
>
>  If you are desperate then try debian stable. Or amd32, or both.

stable might work, but only with a custom kernel - the stock one
didn't like the Promise's much. Which would mean losing Debian's
kernel updates and on headless machines I don't like hand-compiling
kernels as those tend to refuse to boot without intervention. With
stock kernels there is much less margin for user error.
I have had no problems in the past setting up "new" boxes with testing
and letting them "become stable" but maybe you're right and it's just
broken right now.

Still, the people with the most md-raid experience are here and I'd
rather iron out all the issues before putting data anywhere. If
there's no progress for a week I can still try stable.

Just to avoid spamming the list by replying to each suggestion ... as
long as I don't post "yay, it works now!" you can assume the problem's
still there.

Thanks,

C.
