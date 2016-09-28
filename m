From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: Re: moving spares into group and checking spares
Date: Tue, 27 Sep 2016 17:19:03 -0700
Message-ID: <nsf29k$f6s$1@blaine.gmane.org>
References: <nramjg$n07$1@blaine.gmane.org>
 <20160914092959.GA3584@metamorpher.de> <nrc2pm$2a9$1@blaine.gmane.org>
 <20160914232249.6e5fc568@natsu> <nrce27$2km$1@blaine.gmane.org>
 <CAJCQCtQJwOTYsWubd0rV-6PRL4kmVRKLfLr3=7ZPr1Zb3SrwtQ@mail.gmail.com>
 <nrckp2$k8e$1@blaine.gmane.org>
 <CAJCQCtQ1GHdQtShbW3U1o-fmXhT3fHrC7S9BxsxrrOG=0H_p3A@mail.gmail.com>
 <nrd5ak$e8c$1@blaine.gmane.org>
 <CAJCQCtRW9REafzmyk+W6aVxqxMUWCdXNkrST1e7udrH-zp26Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJCQCtRW9REafzmyk+W6aVxqxMUWCdXNkrST1e7udrH-zp26Uw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Chris Murphy wrote on 09/14/2016 08:51 PM:
> On Wed, Sep 14, 2016 at 9:42 PM, scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org> wrote:
>
>> 00 80 00
>> Sep 12 08:05:34 hind kernel: [1350051.023847] end_request: critical medium
>> error, dev sdk, sector 598457896
>> Sep 12 08:05:35 hind kernel: [1350051.385810] md/raid:md0: read error
>> corrected (8 sectors at 598455848 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385826] md/raid:md0: read error
>> corrected (8 sectors at 598455856 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385834] md/raid:md0: read error
>> corrected (8 sectors at 598455864 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385840] md/raid:md0: read error
>> corrected (8 sectors at 598455872 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385847] md/raid:md0: read error
>> corrected (8 sectors at 598455880 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385853] md/raid:md0: read error
>> corrected (8 sectors at 598455888 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385859] md/raid:md0: read error
>> corrected (8 sectors at 598455896 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385865] md/raid:md0: read error
>> corrected (8 sectors at 598455904 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385873] md/raid:md0: read error
>> corrected (8 sectors at 598455912 on sdk1)
>> Sep 12 08:05:35 hind kernel: [1350051.385880] md/raid:md0: read error
>> corrected (8 sectors at 598455920 on sdk1)
>> Sep 12 13:39:43 hind kernel: [1370087.022160] md: md0: data-check done.
>>
>>
>> so it seems to be working?  although the sector reported by libata is
>> different than what md corrected
>
> Looks like it replaced the entire chunk that includes the bad sector.
> Is the chunk size 32KiB?
>

No it is 512K, and the sector reported by libata is almost 2000 sectors 
different than what mdadm reported


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
