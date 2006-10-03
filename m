From: syrius.ml@no-log.org
Subject: Re: old raid tools dangerous with 2.6.18?
Date: Tue, 03 Oct 2006 20:32:18 +0200
Message-ID: <8764f1jlpw.874puljlpw@873ba5jlpw.message.id>
References: <7744a2840609281120g5a4308d5id79ea8d487e7ae2b@mail.gmail.com>
	<87lknz998s.87k63j998s@87irj3998s.message.id>
	<17698.3572.190300.504962@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17698.3572.190300.504962@cse.unsw.edu.au> (Neil Brown's message
	of "Tue, 3 Oct 2006 17:15:00 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Richard Bollinger <rabollinger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

>> > It appears that raidhotadd doesn't always trigger a resync under 2.6.18.
>> >
>> > Starting with a broken raid1 mirror:
>> 
>> Same with evms and 2.6.18. it does not trigger the raid1 resync in any
>> case. (while it does with 2.6.17)
>> Have these tools to be updated ?
>
> Well, mdadm-2.x should work, but this is a serious bug in md.
>
> The following patch fixes it and should go in 2.6.18.1.

yeah, perfect, Thanks a lot !

-- 
