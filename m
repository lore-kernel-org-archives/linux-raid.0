From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Speed variation depending on disk position (was: Linux SW RAID: HW
 Raid Controller/JBOD vs. Multiple PCI-e Cards?)
Date: Sat, 05 May 2007 23:37:12 +0200
Message-ID: <463CF908.6000602@rabbit.us>
References: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan> <20070505205456.GA17112@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070505205456.GA17112@tuatara.stupidest.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Wedgwood wrote:
> <snip>
> 
> Also, 'dd performance' varies between the start of a disk and the end.
> Typically you get better performance at the start of the disk so dd
> might not be a very good benchmark here.
> 

Hi,
Sorry for hijacking this thread, but I was actually planning to ask this
very same question. Is the behavior you are describing above
manufacturer dependent or it is pretty much dictated by the general
design of modern drives? I have an array of 4 Maxtor sata drives, and
raw read performance at the end of the disk is 38mb/s compared to 62mb/s
at the beginning.

Thanks
