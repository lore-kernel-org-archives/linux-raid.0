From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Mon, 15 Nov 2004 16:55:21 +0000
Message-ID: <4198DF79.8080809@dgreaves.com>
References: <200411132039.iADKdDN07474@www.watkins-home.com> <41968282.6060306@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41968282.6060306@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>, =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mru@inprovide.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your help guys.

I'm back up with a full complement of disks and data.

It turns out that despite the 'auto reallocate failed' in this message:

Nov 12 09:45:40 cu kernel: Current sda: sense key Medium Error
Nov 12 09:45:40 cu kernel: Additional sense: Unrecovered read error - 
auto reallocate failed
Nov 12 09:45:40 cu kernel: end_request: I/O error, dev sda, sector 221992599

The disk is actually good according to 'badblocks -w -v -s -c 1024 
/dev/sde 222000000 221800000'
(I did a full scan too).

Checking for bad blocks in read-write mode
 From block 221800000 to 222000000
Testing with pattern 0xaa: done
Reading and comparing: done
Testing with pattern 0x55: done
Reading and comparing: done
Testing with pattern 0xff: done
Reading and comparing: done
Testing with pattern 0x00: done
Reading and comparing: done
Pass completed, 0 bad blocks found.

Now all I need is SMART through libata.

David

