From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: doubt about raid 'quality'
Date: Tue, 17 Jul 2012 16:12:14 +0800
Message-ID: <CA+sTkh5CzbpRMr=ZNgDMxdQcceQHNK_rhLGpxN_LvPab-mS2wA@mail.gmail.com>
References: <CABYL=TobGA_eHqfLQXMnTJ8B8hPQ2B1HrBvTAdM3XAhn8x27uw@mail.gmail.com>
 <CADNH=7G7FXj7skqQ7_P54-GM6rDgAcUPBuKnFrQ6-qGbRNsf_g@mail.gmail.com> <CABYL=Tr=tMxmNhTz=U0bUae+f8rj+44jcnHTS0uguDqnXvJA5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=Tr=tMxmNhTz=U0bUae+f8rj+44jcnHTS0uguDqnXvJA5A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 17 July 2012 11:00, Roberto Spadim <roberto@spadim.com.br> wrote:
> humm and how i know if the check is ok?

   Kinda like that: watch -n3 cat /proc/mdstat
/sys/block/md123/md/mismatch_cnt -- if you want to keep your finger on
its pulse, or simply cat the counter's file when it's done.

   Neil, I have already thought bout it -- maybe check/repair action
should output mismatch_cnt into dmesg's buffer after its completion?

--
