From: Mark Lord <liml@rtr.ca>
Subject: Re: How to configure 36 disks ?
Date: Mon, 23 Mar 2009 12:22:08 -0400
Message-ID: <49C7B730.7030506@rtr.ca>
References: <174852.24274.qm@web51309.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <174852.24274.qm@web51309.mail.re2.yahoo.com>
Sender: owner-linux-aio@kvack.org
To: Jon@eHardcastle.com
Cc: Raz <raziebe@gmail.com>, Bill Davidsen <davidsen@tmr.com>, linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Jon Hardcastle wrote:
> I'd like to understand how you even go attaching that many devices to a system.. I am 'comparatively' new to this.. and have a 6 raid5 system.. not enterprise.. and i have slammed into case/power/sat slot issues already. What sort of hardware must one use to grow to a 36 array system!
..

Here's one way:

  -- four onboard SATA ports
  -- plus four add-in PCI/PCIX/PCIe 8-port Marvell SATA cards.
  -- and a honkin' huge PSU!

:)

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
