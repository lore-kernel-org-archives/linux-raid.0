From: Shaohua Li <shli@kernel.org>
Subject: Re: Enable the skip_copy feature will results in data integrity
 issue in raid5 degraded mode.
Date: Tue, 14 Feb 2017 16:36:23 -0800
Message-ID: <20170215003623.swcqwm4pban6y66m@kernel.org>
References: <CAByoP04pSvxrb_ubNXjaneHvBMPVrMyMj5QgmBSfXsCa4D=5AA@mail.gmail.com>
 <20170214194851.3txkw3nrcxczejyv@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170214194851.3txkw3nrcxczejyv@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chien Lee <chienlee@qnap.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 14, 2017 at 11:48:51AM -0800, Shaohua Li wrote:
> On Mon, Feb 13, 2017 at 05:07:45PM +0800, Chien Lee wrote:
> > Hello,
> > 
> > 
> > Recently we find a bug about skip_copy feature in raid5 degraded mode.
> > In the beginning, we enable the skip_copy feature to speed up system’s
> > write performance. But when the system has database read/write I/O
> > continually in raid5 degraded mode, the Mongo DB will detect the
> > checksum error and generate related debug log. The following is the
> > testing detail.
> > 
> > 
> > a. Enable skip_copy
> >     --> Checksum error logs from Mongo DB
> > 
> > 2017-02-06T11:54:56.537+0800 E STORAGE  [conn7] WiredTiger (0)
> > [1486353296:537114][52:0x7f98396a4700],
> > file:collection-110-3235234017846331078.wt,  WT_CURSOR.next: read
> > checksum error for 4096B block at offset 61440: calculated block
> > checksum of 1363526237 doesn't match expected checksum of 2969711960
> > 
> > 
> > b. Disable skip_copy
> >     --> Mongo DB has no checksum error.
> > 
> > 
> > We've pretty sure that it must be a bug by our repeated database I/O
> > testing. When skip_copy feature is enabled, the raid5/raid6 always
> > causes the mongo DB checksum error in degraded mode less than one
> > hour. On the contrary, it will never cause this abnormal situation
> > when the skip_copy feature is disabled. Besides, because the skip_copy
> > feature only affects the write action instead of read action, I think
> > it should be the write action in degraded mode while skip_copy feature
> > is enabled cause this bug.
> > 
> > 
> > Please kindly provide us some help or idea about the root cause and solution.
> 
> Thanks for the reporting, I'll look at it. In the meaning time, do you have a
> quick way which I can use to reproduce the issue?

Can't find anything suspicious after checking a while. Can you describe the
setup/test in detail? like if there is sync running, IO error?
