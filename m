From: David Greaves <david@dgreaves.com>
Subject: Re: RAID1 write order fidelity
Date: Thu, 31 Jul 2008 17:49:51 +0100
Message-ID: <4891ED2F.30301@dgreaves.com>
References: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>
Sender: linux-raid-owner@vger.kernel.org
To: aristizb@ualberta.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

aristizb@ualberta.ca wrote:
> Hi,
> 
> I am currently working with a software Linux RAID1, with external bitmap
> and no write-behind option. Does the RAID controller keep the write
> order fidelity?.
> 
> If an application writes some blocks on the RAID device in a particular
> order, can I ensure that these blocks will be written to the devices
> conforming the RAID on the same order, or at least on the main disk?
> (disk 0 on the RAID).

I suspect you need to do some research on 'barriers'.

I think the answer at present is 'no'.

Hence messages like:
Filesystem "md0": Disabling barriers, not supported by the underlying device


> The version of mdadm I am suing is 2.6.2.
That's not important. The kernel version is; that's where the md driver lives.

David
