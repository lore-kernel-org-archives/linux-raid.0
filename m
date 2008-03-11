From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: md-raid5, dm-crypt, alignment and readahead
Date: Wed, 12 Mar 2008 00:47:02 +0100
Message-ID: <bb145bd20803111647h13685bd8w4088138316667524@mail.gmail.com>
References: <bb145bd20803100910l6cfe250bs631184b493a23e04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803100910l6cfe250bs631184b493a23e04@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dm-crypt@saout.de
List-Id: linux-raid.ids

>  Is there a difference between running blockdev --setra and echo-int to
>  /sys/block/.../read_ahead_kb for devices that have the entry in /sys?

To answer myself, blockdev --setra seems to change
/sys/block/.../read_ahead_kb, so I'll just always use that.

>  How is readahead handled when "stacked" virtual block devices are
>  involved?

Ran quite a few tests and readahead at any layer but the top layer did
not have any effect. This means that read ahead blocks will always be
decrypted. Oh well ...

Comments on the other issues still welcome :-)


Also, I've been having responsiveness problems with 2.6.22 - accessing
an md-raid5 and/or md-raid5+dm-crypt device in certain ways (surefire
test case = mke2fs) would block ANY disk I/O on the system, including
to/from the SCSI system disk (also encrypted) for minutes at a time.
Already running apps would run fine as long as they did no disk
accesses, but running a simple 'cat' would be too much.

It seems that something related to dm-crypt has some serious
congestion issues and after finally digging up a few threads about
loosely related problems I tried 2.6.24, which allegedly had improved
in related areas. Result:

+ (other) system I/O does not just stop during mke2fs anymore
- running apps are sluggish, ssh input is laggy (wasn't before)
- bonnie++ (sequential) write performance has dropped by more than 20%
- getting "slab: cache kmem_cache error: free_objects accounting
error" messages, which may be totally unrelated but is worrying
nonetheless.

Can't say I'm happy with either kernel's behaviour - any ideas?


C.
