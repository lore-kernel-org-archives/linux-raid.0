From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid0 fail to detect drive failure
Date: Wed, 02 Nov 2005 12:08:58 +0300
Message-ID: <4368822A.4050400@tls.msk.ru>
References: <1130860974.9447.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1130860974.9447.19.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ming Zhang wrote:
> Hi folks
> 
> I have a raid0 on top of 2 sata disk sda and sdb. after i hot unplug
> sda, the raid0 still shows online and active. run dd to write to it will
> fail and dmesg shows scsi io error. but /proc/mdstat shows everything is
> ok.

Since raid0 isn't relly raid (as Redundrand) and can't really do
anything with IO errors on component devices, this behaviour
(returning IO errors to the application) is the only sane way
to go.  It should not fail just like when your disk drive has
a bad sector on it, the whole partition (or whole disk) with
that bad sector isn't "marked as failed".  So what you see is
exactly correct behaviour, in my opinion anyway.

/mjt
