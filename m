From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID migration from 2.4 -> 2.6
Date: Tue, 17 Aug 2004 02:55:14 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41213B52.60903@tls.msk.ru>
References: <20040812152939.GD5326@romulus.a-s-i.com> <20040816223541.GA1197@romulus.a-s-i.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040816223541.GA1197@romulus.a-s-i.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bob Glamm wrote:
[]
> I'm not sure why the devices can't be found: the Adaptec driver appears
> to go through its initialization routines just fine and find all the
> disks.

How about sd_mod (scsi disk module)?  Is it loaded (or compiled into the
kernel) together with the adaptec driver?  Does the kernel prints a line
like
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
(partition layout) for all your disks?

/mjt
