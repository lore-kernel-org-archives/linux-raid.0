From: Christian Pernegger <pernegger@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 22:46:49 +0200
Message-ID: <bb145bd20910231346h44c26b49x38af357e15d97597@mail.gmail.com>
References: <70ed7c3e0910221840o795a61b9u77774725386868e2@mail.gmail.com>
	 <222314.82857.qm@web38801.mail.mud.yahoo.com>
	 <a43edf1b0910231332t48bb8357ib2bd9351a913fe5d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0910231332t48bb8357ib2bd9351a913fe5d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: adfas asd <chimera_god@yahoo.com>
List-Id: linux-raid.ids

> I believe you are confusing raid with backup.

For lots of people the primary role of RAID is as a protection against
data-loss nowadays. Backups just aren't feasible/cost-effective
anymore for the amounts of data involved. Sticking your head in the
sand and repeating that mantra doesn't change that and it isn't
helping.

> The easiest and cleanest solution is to dd the first and last 100mb or
> so of the disks with /dev/zero.

Great, that'll destroy all hope of getting the data back. You're
really something ...

How about don't panic, post any and all error messages you're getting
(dmesg) and wait?

C.
