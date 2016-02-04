From: Shaohua Li <shli@kernel.org>
Subject: Re: Problem with array raid10 array resync on 4.4.0 (keeps reyncing
 each reboot)
Date: Wed, 3 Feb 2016 17:17:31 -0800
Message-ID: <20160204011731.GA29132@kernel.org>
References: <56A78786.10103@Free.fr>
 <20160126233133.GB12721@kernel.org>
 <56A870AD.4070400@free.fr>
 <20160128182522.GB23378@kernel.org>
 <56AA7176.1020508@free.fr>
 <56AE9214.3030206@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AE9214.3030206@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Valette <eric.valette@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 01, 2016 at 12:00:36AM +0100, Eric Valette wrote:
> On 28/01/2016 20:52, Eric Valette wrote:
> >On 28/01/2016 19:25, Shaohua Li wrote:
> >
> >If really needed can rebuild a 4.4 kernel and boot it. What do you mean
> >by special config? I can send you my kernel .config once rebuild
> >(oldconfig from 4.1.16)
> 
> Linux nas2 4.4.1 #1 SMP Sun Jan 31 23:46:26 CET 2016 x86_64 GNU/Linux

Nothing useful. Did you try stop the array and reassemble it in 4.4 and check
if resync runs? I can only imagine the reboot script didn't clean shutdown the
array and trigger the issue. A stop/reassemble circle will tell us if this is
the issue.

Thanks,
Shaohua
