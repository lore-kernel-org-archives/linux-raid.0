From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 09:31:08 -0600
Message-ID: <47A72FBC.9090701@pobox.com>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A72061.3010800@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Eric,

Thanks very much for your note. I'm becoming very leery of resiserfs at 
the moment... I'm about to run another series of crash tests.

Eric Sandeen wrote:
> Justin Piszcz wrote:
> 
>> Why avoid XFS entirely?
>>
>> esandeen, any comments here?
> 
> Heh; well, it's the meme.

Well, yeah...

> Note also that ext3 has the barrier option as well, but it is not
> enabled by default due to performance concerns.  Barriers also affect
> xfs performance, but enabling them in the non-battery-backed-write-cache
> scenario is the right thing to do for filesystem integrity.

So if I understand you correctly, you're stating that current the most 
reliable fs in its default configuration, in terms of protection against 
power-loss scenarios, is XFS?


-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "There is something fundamentally wrong with a country [USSR] where
   the citizens want to buy your underwear."  -- Paul Thereaux
