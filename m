From: berk walker <berk.walker-H+0wwilmMs3R7s880joybQ@public.gmane.org>
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Thu, 30 Dec 2004 15:54:44 -0500
Message-ID: <41D46B14.2080301@verizon.net>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-return-671-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <41D45C1F.5030307-XAri/EZa3C4vJsYlp49lxw@public.gmane.org>
To: Michael Tokarev <mjt-XAri/EZa3C4vJsYlp49lxw@public.gmane.org>
Cc: "Peter T. Breuer" <ptb-H863UKrwfTZ6bVb9jLZWJQ@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-crypt-4q3lyFh4P1g@public.gmane.org
List-Id: linux-raid.ids

Michael Tokarev wrote:

> Peter T. Breuer wrote:
>
>> In gmane.linux.raid Georg C. F. Greve <greve-BSDwwRMYa8fNLxjTenLetw@public.gmane.org> wrote:
>>
>> Yes, well, don't put the journal on the raid partition. Put it
>> elsewhere (anyway, journalling and raid do not mix, as write ordering
>> is not - deliberately - preserved in raid, as far as I can tell).
>
>
> This is a sort of a nonsense, really.  Both claims, it seems.
> I can't say for sure whenever write ordering is preserved by
> raid -- it should, and if it isn't, it's a bug and should be
> fixed.  Nothing else is wrong with placing journal into raid
> (the same as the filesystem in question).  Suggesting to remove
> journal just isn't fair: the journal is here for a reason.
> And, finally, the kernel should not crash.  If something like
> this is unsupported, it should refuse to do so, instead of
> crashing randomly.
>
> /mjt
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
I might have missed some of this thread....
but have you tried this on a completely different box?  I have seen, and 
am fighting some problems such as yours, and having nothing to do with raid.

If you haven't, then try it.  You might get different results.  Hardware 
can sometimes be a dog to chase down, problemwise.
b-
