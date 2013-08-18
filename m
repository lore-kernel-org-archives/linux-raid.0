From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Small chunk size read performance penalty
Date: Sun, 18 Aug 2013 19:16:51 -0300
Message-ID: <CAH3kUhGs1nKD6qpo2qNWa85d+eA_Oxa9WyZEVq3f5eNk5ZyuCA@mail.gmail.com>
References: <kurge6$qi0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kurge6$qi0$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i'm not sure, but maybe the problem is the same of small chunk size of raid-0
the head move a lot for small works, while it could move less and do many job

but i'm not sure about it

2013/8/18 Ian Pilcher <arequipeno@gmail.com>:
> Can anyone point me to a good explanation of the read performance impact
> of small (RAID-5 and RAID-6) chunk sizes?
>
> I understand why large chunks hurt write performance, but I haven't been
> able to reason through the small-chunk/read case, and my Interweb
> searches haven't really turned anything up.
>
> The "read penalty" is definitely there; I can see it in the test data
> from my NAS.  I just don't understand *why* it's there.
>
> Thanks!
>
> --
> ========================================================================
> Ian Pilcher                                         arequipeno@gmail.com
> Sometimes there's nothing left to do but crash and burn...or die trying.
> ========================================================================
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
