From: Shaohua Li <shli@kernel.org>
Subject: Re: raid5 using group_thread
Date: Wed, 19 Jul 2017 11:36:15 -0700
Message-ID: <20170719183615.sniln62g7xti6ovi@kernel.org>
References: <721dda9c0d5f4df0838a7365a53e8e04@IL-EXCH01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <721dda9c0d5f4df0838a7365a53e8e04@IL-EXCH01.marvell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ofer Heifetz <oferh@marvell.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 19, 2017 at 01:00:45PM +0000, Ofer Heifetz wrote:
> Hi,
> 
> I have a question regarding raid5 built using group_thread and async_tx, from code (v4.4 and even v4.12) I see that only raid5d invokes async_tx_issue_pending_all, shouldn't the raid5_do_work also invoke this API to issue
> all pending requests to HW?
> 
> I am assuming that there is no sync mechanism between the raid5d and the raid5_do_work, correct me if I am wrong.

Can't remember why we don't call async_tx_issue_pending_all in raid5_do_work,
it shouldn't harm. In practice, I doubt calling it makes a change, because when
workers are running, raid5d are running too. Did you benchmark it?

Thanks,
Shaohua
