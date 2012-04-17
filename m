From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Tue, 17 Apr 2012 07:46:03 -0700
Message-ID: <CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
References: <20120417083552.483324288@kernel.org>
	<20120417084632.306032602@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084632.306032602@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

On Tue, Apr 17, 2012 at 1:35 AM, Shaohua Li <shli@kernel.org> wrote:
> Discard for raid4/5/6 has limitation. If discard request size is smal=
l, we do
> discard for one disk, but we need calculate parity and write parity d=
isk. =A0To
> correctly calculate parity, zero_after_discard must be guaranteed.

I'm wondering if we could use the new bad blocks facility to mark
discarded ranges so we don't necessarily need determinate data after
discard.

=2E..but I have not looked into it beyond that.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
