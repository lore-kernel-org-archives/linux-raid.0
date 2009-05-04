From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Query regarding stripe management in linux md-raid
Date: Mon, 04 May 2009 19:04:04 +0200
Message-ID: <87y6tclrzv.fsf@frosties.localdomain>
References: <fbae8f520904280702h736197d6ibfdf0212bf1923d2@mail.gmail.com>
	<18935.36392.65600.930716@notabene.brown>
	<fbae8f520904290027x6b65419co164c61db7b249223@mail.gmail.com>
	<87zldwjybm.fsf@frosties.localdomain>
	<fbae8f520905020018mc6bb23cw51301052ff164928@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fbae8f520905020018mc6bb23cw51301052ff164928@mail.gmail.com>
	(Kunal Kushwaha's message of "Sat, 2 May 2009 12:48:18 +0530")
Sender: linux-raid-owner@vger.kernel.org
To: Kunal Kushwaha <kunal.kushwaha@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kunal Kushwaha <kunal.kushwaha@gmail.com> writes:

> Hi Goswin,
>
> My understanding of chunk size is that,  it is minimum unit of data
> that is used for read/write.
> Chunk size defines, amount of data written on one disk after breaking
> it in equal no of chunks.
> Chunk size = Stripe size /  (disks in array - parity disks)
>
> so for raid 5, chunk_size = Stripe_Size / (total_disks -1)
> and for raid 6, chunk_size = Stripe_Size / total_disks -2)
>
> and parity is also written in terms of chunk size.
>
> Now considering a case where IO request came for complete 1 stripe, we
> need buffer, for 1 stripe, but since we allocated 1 page per chunk,
> instead of 64k buffer we have only 4k buffer, So how this is handled?

No. read/write are generaly handled on a page size level, which almost
always means 4k. If you think about it you can easily split a chunk
into 4k bits and handle each one independently.

MfG
        Goswin
