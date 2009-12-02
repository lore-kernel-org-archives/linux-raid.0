From: Asdo <asdo@shiftmail.org>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Wed, 02 Dec 2009 11:15:29 +0100
Message-ID: <4B163E41.1050407@shiftmail.org>
References: <4B0E7111.20202@shiftmail.org>
 <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan>
 <4B0E8B75.2030006@shiftmail.org>
 <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan>
 <4B0ED0DF.10502@shiftmail.org>
 <alpine.DEB.2.00.0911261554170.14297@p34.internal.lan>
 <4B0FD689.9030904@shiftmail.org> <4B101653.8040904@shiftmail.org>
 <20091128082133.62dcb122@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20091128082133.62dcb122@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> If the array is marked read-only, it wont do a scrub.
>
> However if you simply don't have any filesystem mounted, then the array
> will remain 'clean' and any failures are less likely cause further
> failures.
>
> So doing it off line is a good idea, but setting the array to read-only
> won't work.
>   

Thanks for the info Neil,
would mounting the filesystems readonly be safe in the same way?
(I might try to rsync some data out during the scrub)
Thank you
Asdo
