From: David Brown <david.brown@hesbynett.no>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Wed, 01 May 2013 15:57:21 +0200
Message-ID: <51811F41.3030800@hesbynett.no>
References: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com> <20130422142211.71a1ae8e@notabene.brown> <CAA9_cmdbZ_K5Wvo7BH1nPGvttL5As1ncnbPK1ax3TFvGOch6zw@mail.gmail.com> <20130429112957.4bd6cd71@notabene.brown> <CAA9_cmd0kuynynwXmNN_0yf-Go1iy4LeqPhXx6pDbEo5kUV1AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmd0kuynynwXmNN_0yf-Go1iy4LeqPhXx6pDbEo5kUV1AA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
List-Id: linux-raid.ids

On 30/04/13 23:32, Dan Williams wrote:
> On Sun, Apr 28, 2013 at 6:29 PM, NeilBrown <neilb@suse.de> wrote:
>> On Fri, 26 Apr 2013 14:35:27 -0700 Dan Williams <djbw@fb.com> wrote:
> [..]
>> which looks odd as when that expands out, we add Q_old to Q_old and as  '+'
>> is 'xor', it disappears.  Maybe you mean:
>>
>>    Q_new = Q_sub + g^i * Di_new
>> ??
>>
>> This is exactly the sort of thing I wanted to see, but I hoped it wouldn't
>> confuse me like it seems to be doing :-)
>
> Sorry, yes for completeness the approach includes all the modified
> data blocks (Di...Dm) and zero pages for the unmodified blocks in the
> gen_syndrome.
>
> Q_sub = Q_old + g^i * Di_old ... + g^m * Dm_old + (zero blocks)
> Q_new = Q_sub + g^i *Di_new ... + g^m * Dm_new + (zero blocks)
>
>
> For David, we're using vector processing (SSE) in gen_syndrome()
> rather than individual multiplications by table lookup.
>

Certainly SSE is the best way to go for multiply-by-g, and when doing a 
full Q generation, I believe it is calculated as:

Q = D_0 + g * (D_1 + g * (D_2 + g * ...))

But in this case, if you want to do a rmw of disk 10, you have 9 
multiply-by-g operations in a row.  Is that really faster than doing a 
single multiply-by-g^9 table lookup?

Of course, getting the very fastest implementation is not the most 
important thing.  Avoiding extra disk access will make orders of 
magnitude more difference than the choice of parity algorithm, and I 
could imagine that using the existing SSE system will mean fewer code 
changes.


