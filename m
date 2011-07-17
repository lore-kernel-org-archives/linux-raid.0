From: Gordon Henderson <gordon@drogon.net>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Sun, 17 Jul 2011 17:48:22 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1107171744110.3337@unicorn.drogon.net>
References: <201107162140.58883.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107162140.58883.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 16 Jul 2011, Pol Hallen wrote:

> Hi folks :-)
>
> after assembled a new hw (xeon, ich10 controller with 5 disks of 2Tb wd -
> radi5) I have slow write performance:
>
> 20Mb/s :-(((

In addition to the other comments so-far, are these drives WDC EARS 
drives?

What's the output of

   hdparm -i /dev/sda

If it's something like

    Model=WDC WD20EARS-00MVWB0, FwRev=50.0AB50, SerialNo=WD-WMAZ20098633
                  ^^^^

then it has 4KB sectors.

If so, then you'll have to make absolutely sure the partitions are aligned 
on a 4KB boundary.

What does the output of

   sfdisk -d /dev/sda

look like? (where /dev/sda is one of the disks on your array)

The start of each partition ought to be divisible by 64 evenly for optimal 
results.

Gordon
