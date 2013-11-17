From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: dmaengine 3.13 v2
Date: Sun, 17 Nov 2013 21:58:13 +0530
Message-ID: <20131117162813.GJ8834@intel.com>
References: <CAPcyv4iQQutRipP+XQGPAxfQVj9C_K9SEjGF_Rd1=ZkgTZnjow@mail.gmail.com>
 <20131116065213.GI8834@intel.com>
 <CAPcyv4iMY84dbZLtZceAKnhbkDP-+Vszss8BYriB9pva6nxCfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4iMY84dbZLtZceAKnhbkDP-+Vszss8BYriB9pva6nxCfg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-raid <linux-raid@vger.kernel.org>, Jon Mason <jon.mason@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-raid.ids

On Sat, Nov 16, 2013 at 10:37:38AM -0800, Dan Williams wrote:
> On Nov 15, 2013 11:48 PM, "Vinod Koul" <vinod.koul@intel.com> wrote:
> 
> > While the dmaengine-v2 has:
> >
> > commit 82a1402eaee5dab1f3ab2d5aa4c316451374c5af
> > Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > Date:   Wed Oct 30 12:01:43 2013 -0300
> >
> > Which also explains the diff I got with test. I have pushed my merge to
> > dan_merge2 for your ref. You next branch also doesnt show this commit and
> these
> > are missing below. I guess we need this for the fix. Looks like you tagged
> > without these patches. I can go ahead and merge commit
> > bad6f9dba84e7ddc448f306ce4b289dcaa95b9f9 directly if you want.
> 
> No, use the tag directly.  We're still sorting those ntb patches out
> internally and I accidentally included them in the test branch.
Fine, I have pushed now as next, pls do verify

> 
> Thanks!
> 
> Sent from my phone so excuse HTML
Looks like you managed to send this one nicely taht too inlined well :)

-- 
~Vinod
