From: Emmanuel Noobadmin <centos.admin@gmail.com>
Subject: Re: Recommended sw raid setup
Date: Sun, 3 Jul 2011 15:46:06 +0800
Message-ID: <CAAYorBKcqwC5o2yiC3Jftf9j_pcush-WxwXdVVVv=8q-qZw9GQ@mail.gmail.com>
References: <BANLkTinbBu6zX-6s2NYH5BQvnaJZJYt_BA@mail.gmail.com>
	<BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Obaterspok <john.obaterspok@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/2/11, John Obaterspok <john.obaterspok@gmail.com> wrote:
> Any recommendation for what SATA drives to get? Should I get
> enterprise drives that support TLER (or alike), or will the greener
> low cost drives be enough, is there something in between?
>
> Is it better to buy 4 low cost drives in RAID1 or 3 enterprise drives in
> RAID5?

If you can afford either, I would personally recommend 4 low cost
drives in RAID 1. Since the drives are mirror, recovery is
straightforward and risk free. You could even put them in removable
enclosures and do backup simply by swapping out one drive of each
array.

Try to get drives from different manufacturers. You don't want to face
the kind of nightmares some of us had when/if there was a batch/model
problem, RAID can't help if all your drives brick or fail at the same
time due to the same problem.
