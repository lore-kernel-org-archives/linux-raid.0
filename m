From: Danilo Godec <danci@agenda.si>
Subject: Re: couple of seemingly dumb questions
Date: Sat, 20 Apr 2002 00:26:32 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0204200023260.25558-100000@duplo.agenda.si>
References: <5.1.0.14.2.20020419100004.03944e40@mail.harddata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20020419100004.03944e40@mail.harddata.com>
To: Maurice Hilarius <maurice@harddata.com>
Cc: bo <bo@sosnetwork.net>, Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 19 Apr 2002, Maurice Hilarius wrote:

> >If I have a h/w support for IDE hot swap then what do you recommand for
> >the same as you suggested for scsi below?
> The issue seems to be one of "while the hardware supports replacing drives
> and bus rescans, the Linux IDE driver may not"
>
> Or am I completely missing the point here???

Something like that. However, IDE RAID cards *may* handle the issue by
providing a 'pseudo' device acting like a disk to the kernel. I guess the
kernel does need special support (a driver) for such card(s).

In a couple of days I may know more about it as I just got a motherboard
with an on-board Promise Fasttrak... :)

  D.


