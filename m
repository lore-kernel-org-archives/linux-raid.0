From: Neil Brown <neilb@suse.de>
Subject: Re: Now [...] it is possible for raid5d to distribute stripe
 handling  over multiple cores.
Date: Wed, 25 Nov 2009 07:47:00 +1100
Message-ID: <20091125074700.7b0f0989@notabene.brown>
References: <43d009740911240952m5aa9aa5bp229705b5fda4f399@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740911240952m5aa9aa5bp229705b5fda4f399@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 Nov 2009 00:52:06 +0700
Igor Podlesny <for.poige+linux@gmail.com> wrote:

>     Hello, Linux RAID people. :-)
> 
>     It ( http://tinyurl.com/raid-over-cores ) is quite an interesting
> change due to it promises less latency and more bandwidth (does it
> really?), but as far as I see, currently this feature is turned OFF:
> CONFIG_MULTICORE_RAID456: "If unsure, say N".
> 
>     So, I'd like to ask the authors what are worst case scenarios when
> having it turned ON?
> 
>     Is "kissing data good-bye" amongst one of them? :-)
>

Worst case is that performance falls through the floor, or becomes
very unpredictable, or possibly even hangs your machine (though that is
unlikely).
There is no reason to expect that enabling this config option will have
any effect on data integrity.

If you do experiment, please post your results.

NeilBrown
