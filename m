From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: md device is read only mode
Date: Mon, 9 Jul 2012 19:34:07 +0200
Message-ID: <20120709173406.GA4206@lazy.lzy>
References: <20120705172748.GA6464@lazy.lzy>
 <20120709114022.58f5d52b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120709114022.58f5d52b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

please see one comment below.

On Mon, Jul 09, 2012 at 11:40:22AM +1000, NeilBrown wrote:
[...]
> The mount system call will notice that the device is read-only, and will make
> assume the read-only mount option.

OK, so it should work as expected.

The story was this.
After fixing the RAID-5 superblock problem, we
wanted to see if the filesystem was still OK.
So we started the RAID in r/o mode (so to avoid
any possible further damage from mount) and then
mounted the filesystem (actually, now that I
think of it, there was an LVM layer in the middle).
This mount caused a kernel error report (I do
not know if BUG() or else).

Is there any explanation for that?

Thanks,

bye,

-- 

piergiorgio
