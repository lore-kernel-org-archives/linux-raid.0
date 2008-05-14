From: David Greaves <david@dgreaves.com>
Subject: Re: questions about softraid limitations
Date: Wed, 14 May 2008 11:45:15 +0100
Message-ID: <482AC2BB.5010602@dgreaves.com>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002801c8b55a$60e4a360$0404a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <djani22@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janos Haar wrote:
> Hello list, Neil,

Hi Janos

> I have worked on a faulty hw raid card data recovery some days before.
> The project is already successfully done, but i run into some limitations.

Firstly, are you aware that Linux SW raid will not understand disks written by
hardware raid.

> Than try to build an "old fashion" linear arrays from each disks + 64k
> another blockdevice. (for store the superblock)
> But the mdadm refused to _build_ the array, because the source scsi
> drive is jumpered to readonly. Why? :-)
This will not allow md to write superblocks to the disks.

> 
> I try to build the array with --readonly option, but the mdadm still
> dont understand what i want. (yes, i know, rtfm...)
This will start the array in readonly mode - you've not created an array yet
because you haven't written any superblocks...


> Its OK, but what about building a readonly raid 5 array for recovery
> usage only? :-)
That's fine. If they are md raid disks. Yours aren't yet since you haven't
written the superblocks.


David

