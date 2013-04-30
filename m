From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Tue, 30 Apr 2013 14:32:05 -0700
Message-ID: <CAA9_cmd0kuynynwXmNN_0yf-Go1iy4LeqPhXx6pDbEo5kUV1AA@mail.gmail.com>
References: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
	<20130422142211.71a1ae8e@notabene.brown>
	<CAA9_cmdbZ_K5Wvo7BH1nPGvttL5As1ncnbPK1ax3TFvGOch6zw@mail.gmail.com>
	<20130429112957.4bd6cd71@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130429112957.4bd6cd71@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>, David Brown <david.brown@hesbynett.no>
List-Id: linux-raid.ids

On Sun, Apr 28, 2013 at 6:29 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 26 Apr 2013 14:35:27 -0700 Dan Williams <djbw@fb.com> wrote:
[..]
> which looks odd as when that expands out, we add Q_old to Q_old and as  '+'
> is 'xor', it disappears.  Maybe you mean:
>
>   Q_new = Q_sub + g^i * Di_new
> ??
>
> This is exactly the sort of thing I wanted to see, but I hoped it wouldn't
> confuse me like it seems to be doing :-)

Sorry, yes for completeness the approach includes all the modified
data blocks (Di...Dm) and zero pages for the unmodified blocks in the
gen_syndrome.

Q_sub = Q_old + g^i * Di_old ... + g^m * Dm_old + (zero blocks)
Q_new = Q_sub + g^i *Di_new ... + g^m * Dm_new + (zero blocks)


For David, we're using vector processing (SSE) in gen_syndrome()
rather than individual multiplications by table lookup.

--
Dan
