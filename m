From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: One more question about the linux md driver
Date: Thu, 10 Apr 2003 12:28:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E959BA3.4DA2B8FD@SteelEye.com>
References: <200304101446.h3AEklj30240@oboe.it.uc3m.es> <3E9595F8.AC72CC1F@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:

> to use dev_unit() (which basically masks out the minor number from a
> kdev_t, leaving the major number).

...that's not exactly what I meant to say... :)

The minor_shift determines which portion of the device number represents
the "partition" and which portion represents the "disk". The division is
not necessarily along the major/minor line.

--
Paul
