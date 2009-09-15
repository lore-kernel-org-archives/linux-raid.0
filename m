From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 7/9] md/raid6: asynchronous handle_stripe6
Date: Tue, 15 Sep 2009 01:42:34 -0700
Message-ID: <e9c3a7c20909150142y168febb8v25ffe584fad95f2d@mail.gmail.com>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
	 <20090831164139.1696.24706.stgit@dwillia2-linux.ch.intel.com>
	 <19119.9592.91030.892183@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19119.9592.91030.892183@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Mon, Sep 14, 2009 at 10:26 PM, Neil Brown <neilb@suse.de> wrote:
>
> Sorry for the long delay in getting to these. =A0I week's leave recen=
tly
> and that always causes tasks to pile up....
>
> I am happy for this to =A0all go in this merge window. =A0I just have=
 a
> few nits I would like to see changed then I'll pull and push to Linus=
=2E
>
> in this patch:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* now count some things */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(R5_LOCKED, &dev->flags)) s.=
locked++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(R5_UPTODATE, &dev->flags)) =
s.uptodate++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(R5_Wantcompute, &dev->flags))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(++s.compute > 2);
>
> I think having a side-effect in a BUG_ON is very poor form. =A0I shou=
ld
> be able to recompile the code with BUG_ON() becoming a no-op and
> everything should still work.
> So something like:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(R5_Wantcompute, &dev->flags))=
 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++s.compute;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(s.compute > 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>
> please.

Definitely.  Will fix.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
