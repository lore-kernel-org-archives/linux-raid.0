From: Danilo Godec <danci@agenda.si>
Subject: Re: couple of seemingly dumb questions
Date: Sat, 20 Apr 2002 00:22:55 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0204200016170.25558-100000@duplo.agenda.si>
References: <01b501c1e7b9$c3c9e8c0$6501a8c0@bomoon>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01b501c1e7b9$c3c9e8c0$6501a8c0@bomoon>
To: bo <bo@sosnetwork.net>
Cc: Maurice Hilarius <maurice@harddata.com>, Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 19 Apr 2002, bo wrote:

> Danilo,
>
> If I have a h/w support for IDE hot swap then what do you recommand for
> the same as you suggested for scsi below?

I'm not sure, but I guess such H/W support for IDE hot swap would include
an IDE RAID card that would probably handle such things by itself and
kernel wouldn't use disks directly. Instead the RAID card will provide
some 'pseudo' devices which will appear as disks to the kernel.

Most probably this is handled by the special IDE RAID card drivers that
exists in late kernels (Promise Fasttrak).

But if you just want 'normal' hot-swap IDE disks on Linux, you're out of
luck (somebody, correct me if I'm wrong). You could also check out
http://www.linux-ide.org/, where I saw something about IDE hot-swap...

  D.


