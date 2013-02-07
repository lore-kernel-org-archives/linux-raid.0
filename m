From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH v2] mdadm: make --update=homehost work again
Date: Wed, 6 Feb 2013 17:54:09 -0800
Message-ID: <CAKgsxVT7x_fU-EHmXoeR_367en1uVbX5ECtrOs92WcGqaeUjDQ@mail.gmail.com>
References: <1360181237-11760-1-git-send-email-jmaggard10@gmail.com>
	<20130207115328.6b07ade9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130207115328.6b07ade9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 6, 2013 at 4:53 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed,  6 Feb 2013 12:07:17 -0800 Justin Maggard <jmaggard10@gmail.com>
> wrote:
>
>> Commit 1e2b276535cea41c348292a019bdda8a58cb1679 (Report error in --update
>> string is not recognised) broke homehost updating functionality because it
>> depended on each string comparison being done even after we already found
>> a match.  Make it work again by using a goto instead.
>>
>
> Hi Justin,
> thanks for the patch.  Unfortunately I really don't like gotos when they can
> be easily avoided (though they do have their place sometimes).
> So I restructured the code a bit instead - as below.
>

Works for me.  Thanks!

-Justin
