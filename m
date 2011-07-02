From: Drew <drew.kay@gmail.com>
Subject: Re: Recommended sw raid setup
Date: Sat, 2 Jul 2011 14:30:06 -0700
Message-ID: <CACJz6QuzTj3cmESu0eBGgq3rK3wopXZpj9m34N5ecR=uj6FvCQ@mail.gmail.com>
References: <BANLkTinbBu6zX-6s2NYH5BQvnaJZJYt_BA@mail.gmail.com>
 <BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com> <CACJz6Qv=u0-66hwOEg5AeZ2rWuw2OE10ozUKEQGTbuGn0_fgGg@mail.gmail.com>
 <BANLkTing8Ei+najZAFXN_ib0LRmQfS8e9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTing8Ei+najZAFXN_ib0LRmQfS8e9Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I thought that I had read the TLER was not useful for mdraid, so that
> enterprise drives were not really advised for mdraid. Am I wrong about
> this?

TLER just shortens the firmware's error recovery from something like
60 seconds down to 4 seconds. It's mainly useful in hardware RAID but
I can see it being useful with mdraid in the enterprise where you
can't afford to wait for the drive to do it's own recovery attempts.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
