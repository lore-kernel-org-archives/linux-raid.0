From: "James Lamanna" <jlamanna@gmail.com>
Subject: Re: [RFH] Partion table recovery
Date: Thu, 19 Jul 2007 22:25:49 -0700
Message-ID: <aa4c40ff0707192225r6b5e971fy59f78a525697f864@mail.gmail.com>
References: <200707200813.03553.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 7/19/07, Al Boldi <a1426z@gawab.com> wrote:
> As always, a good friend of mine managed to scratch my partion table by
> cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but
> at least the first 100MB are gone.  I can probably live without the first
> partion, but there are many partitions after that, which I hope should
> easily be recoverable.
>
> I tried parted, but it's not working out for me.  Does anybody know of a
> simple partition recovery tool, that would just scan the disk for lost
> partions?

Tried gpart?
http://www.stud.uni-hannover.de/user/76201/gpart/


>
>
> Thanks!
>
> --
> Al

-- James
