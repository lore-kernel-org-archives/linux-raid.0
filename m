From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID1 repair GPF crash w/3.10-rc7
Date: Mon, 8 Jul 2013 16:06:56 -0400
Message-ID: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1307012118450.6694@jlaw-desktop.mno.stratus.com>
 <alpine.DEB.2.02.1307031634440.9749@jlaw-desktop.mno.stratus.com>
 <20130704105337.2a06cbfd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130704105337.2a06cbfd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, kmo@daterainc.com
List-Id: linux-raid.ids

[+cc Kent's new mail?]

On Thu, 4 Jul 2013 10:53:37 +1000
NeilBrown <neilb@suse.de> wrote:
> 
> I would propose "bio_rewind" that exactly undoes any "bio_advance". 
>
> [ ... snip ...]
> 
> Then call that on pbio at the same place we call bio_reset on sbio.
> 
> You could probably also call bio_rewind on sbio, and remove lots of that
> code for setting the bio up again.

This appears to work for my test case (no crashes or post repair
mismatch_cnt):

  mdadm --fail /dev/$MD /dev/sda3
  mdadm --remove /dev/$MD /dev/sda3
  dd if=/dev/urandom of=/dev/$MD bs=1M count=500
  mdadm --stop /dev/$MD

  mdadm --create /dev/$MD --level=1 --assume-clean --raid-devices=2 \
  	--bitmap=internal /dev/sda3 /dev/sdi3
  echo repair > /sys/block/$MD/md/sync_action

I'll reply to this email with the patches that implement your
suggested changes.  Feel free to combine or redo them, posting them here
was the easiest way to provide my signed-off should you need it.

Although it works, having to rewind the bio io_vec index (and
clearing the bi_next pointers) before calling bio_copy_data feels a
bit clunky.  What bio_copy_data is really doing is
"bio_copy_remaining_data in a bio chain," whereas MD wants 
"bio_copy_completed_data from a single bio".

I took a look at Kent's tree and a lot of the block layer handling was
simplified through the bvec_iter.  I don't know if that code is
destined for 3.11.  If so, it would probably be easier to retest and
base any MD changes off of his.  And for 3.10 stable, the minimal
fix would be for MD to just manipulate the bi_idx itself (or revert
calling bio_copy_data altogether.)

Regards,

-- Joe
