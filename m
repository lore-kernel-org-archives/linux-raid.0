From: Helge Hafting <helge.hafting@aitel.hist.no>
Subject: Re: modifying degraded raid 1 then re-adding other members is bad
Date: Wed, 09 Aug 2006 11:01:55 +0200
Message-ID: <44D9A483.1020203@aitel.hist.no>
References: <or8xlztvn8.fsf@redhat.com> <17624.29070.246605.213021@cse.unsw.edu.au> <44D8732C.2060207@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D8732C.2060207@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, Alexandre Oliva <aoliva@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Why we're updating it BACKWARD in the first place?
>   
Don't know this one...
> Also, why, when we adding something to the array, the event counter is
> checked -- should it resync regardless?
If you remove a drive and then add it back with
no changes in the meantime, then you don't want
a resync to happen.  Some people reboot their machine
every day (too much noise, heat or electricity at night),
a daily resync is excessive.

An which drive would you consider
the "master copy" anyway, if the event counts match?

Helge Hafting

