From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2.6.29-rc7] md: fix deadlock when stopping arrays
Date: Fri, 06 Mar 2009 15:20:45 -0700
Message-ID: <1236378045.26719.2.camel@dwillia2-linux.ch.intel.com>
References: <20090305230615.9122.62640.stgit@dwillia2-linux.ch.intel.com>
	 <18864.46162.353471.534054@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18864.46162.353471.534054@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>
List-Id: linux-raid.ids

On Thu, 2009-03-05 at 22:27 -0700, Neil Brown wrote:
> Can you add 
>    Cc: stable@kernel.org
> at the bottom.  Then I'll pull it and send a pull request to Linus.  I
> think it should go straight in.

Done.

The following changes since commit 559595a985e106d2fa9f0c79b7f5805453fed593:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git md-deadlock-fix

Dan Williams (1):
      md: fix deadlock when stopping arrays

 drivers/md/md.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)


Double check that it is commit 5fd3a17e.

Thanks,
Dan

