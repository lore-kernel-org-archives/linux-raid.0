From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: On URE and RAID rebuild - again!
Date: Thu, 31 Jul 2014 09:16:24 +0200
Message-ID: <53D9ED48.9000307@assyoma.it>
References: <53D8ACF0.1070202@assyoma.it>	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>	<53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140731073121.38cd1773@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids


> Yes, you can usually get your data back with mdadm.
>
> With latest code, a URE during recovery will cause a bad-block to be recorded
> on the recovered device, and recovery will continue.  You end up with a
> working array that has a few unreadable blocks on it.
>
> NeilBrown

This is very good news :)
I case of parity RAID I assume the entire stripe is marked as bad, but 
with mirror (eg: RAID10) only a single block (often 512B) is marked bad 
on the recovered device, right?

 From what mdadm/kernel version the new behavior is implemented? Maybe 
the software RAID on my CentOS 6.5 is stronger then expected ;)

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
