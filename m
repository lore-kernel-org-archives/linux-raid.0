From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid-6 cannot reshape
Date: Mon, 6 Apr 2020 17:27:17 +0100
Message-ID: <5E8B5865.9060107@youngman.org.uk>
References: <24a0ef04-46a9-13ee-b8cb-d1a0a5b939fb@shenkin.org>
 <6b9b6d37-6325-6515-f693-0ff3b641a67a@shenkin.org>
 <3135fb29-cfaa-d8ac-264d-fd3110217370@shenkin.org>
 <CAAMCDecyr4R_z3-E8HYwYM4CyQtAY_nBmXdvvMkTgZCcCp7MjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDecyr4R_z3-E8HYwYM4CyQtAY_nBmXdvvMkTgZCcCp7MjQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>, Alexander Shenkin <al@shenkin.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/20 17:12, Roger Heflin wrote:
> When I looked at your detailed files you sent a few days ago, all of
> the reshapes (on all disks) indicated that they were at position 0, so
> it kind of appears that the reshape never actually started at all and
> hung immediately which is probably why it cannot find the critical
> section, it hung prior to that getting done.   Not entirely sure how
> to undo a reshape that failed like this.

This seems quite common. Search the archives - it's probably something
like --assemble --revert-reshape.

Cheers,
Wol
