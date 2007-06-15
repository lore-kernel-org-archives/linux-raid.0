From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: raid5: coding style cleanup / refactor
Date: Thu, 14 Jun 2007 19:39:41 -0700
Message-ID: <e9c3a7c20706141939g12ad831gc1c49bf4887fdb12@mail.gmail.com>
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
	 <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
	 <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com>
	 <e9c3a7c20706131153l289490f2t60db3b5c251a362a@mail.gmail.com>
	 <4671AE5E.4090602@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4671AE5E.4090602@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/14/07, Bill Davidsen <davidsen@tmr.com> wrote:
> When you are ready for wider testing, if you have a patch against a
> released kernel it makes testing easy, characteristics are pretty well
> known already.
>
Thanks I went ahead and put a separate snapshot up on SourceForge:
http://downloads.sourceforge.net/xscaleiop/md-accel-2.6.22-rc4-20070614.patch
[ It's actually based on current git but should apply cleanly to 2.6.22-rc4. ]

If you are so inclined the most up-to-date version is available via git.
git pull git://lost.foo-projects.org/~dwillia2/git/iop md-accel-linus

It should perform identically to vanilla 2.6.22-rc4 MD.

> --
> bill davidsen <davidsen@tmr.com>

Regards,
Dan
