From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: Reproducable OOPS with MD RAID-5 on 2.6.0-test11
Date: Mon, 01 Dec 2003 07:15:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3FCB4CFA.4020302@backtobasicsmgmt.com>
References: <3FCB4AFB.3090700@backtobasicsmgmt.com> <20031201141144.GD12211@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031201141144.GD12211@suse.de>
To: Jens Axboe <axboe@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jens Axboe wrote:

>>Hardware is a 2.6CGHz P4, 1G of RAM (4G highmem enabled), SMP kernel but 
>>no preemption. Kernel config is at:
> 
> 
> Are you using ide or libata as the backing for the sata drives?
> 

libata, two of the disks are on an ICH5 and the other four are on a 
Promise SATA150 TX4.
