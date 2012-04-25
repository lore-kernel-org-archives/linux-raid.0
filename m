From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: Raid1: sdb has a lot mor work then sda
Date: Wed, 25 Apr 2012 09:47:52 +0200
Message-ID: <4F97AC28.7060609@uni-konstanz.de>
References: <4F96BCC9.9080003@marco.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F96BCC9.9080003@marco.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/24/2012 04:46 PM, Daniel Spannbauer wrote:
> Hello,
>
> at the moment I'm trying to find a bottleneck on my lamp-server with
> opensuse 11.4 (Kernel 2.6.37.6)
>
> Sometimes the system has a very poor performance because of a high io-wait.
> If I watch the systems disk-access with "atop -dD" I can see that sda is
> the most of the time at a load of 10%, sdb sometimes is at 100% or
> higher at the same time.
>
> In my opinion in a Raid1-System both disk should have nearly the same load.
>
> Or may I wrong whis this?
>
> Both harddisks where changed 3 Weeks ago, /proc/mdstat shows that the
> rebuild was successfull and the array is functional. Today I've changed
> th SATA-Cable and the Port on the Maindboard of sdb, but the behaviour
> is still the same. Both disks passed the extended smart-self-test.
>
> Any ideas about that?
>
> Regards
>
> Daniel

Are the disks more or less the same in all SMART attributes (from 
smartctl -a)?

I have seen such a behaviour in the case of one disk being marginal, 
and/or having a couple of bad spots which need several trials to be 
read. This always also resulted in longer "smartctl -t long" times than 
usual, but did not always show up clearly in the SMART output (or I 
looked at the wrong attributes).

I'd try to exchange the disk.

HTH,

Kay




