From: Brad Dameron <brad@seatab.com>
Subject: Re: maximum size
Date: Tue, 27 Sep 2005 09:18:52 -0700
Message-ID: <1127837933.16750.4.camel@dhcpc226.office.pivotlink.com>
References: <43394753.9040107@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43394753.9040107@bppiac.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2005-09-27 at 15:21 +0200, Farkas Levente wrote:
> hi,
> i'd been already asked, but don't get any answer. what is the maximum 
> size of a raid5 and raid5 partition in kerenel 2.6? i try to find the 
> answer but found only kernel 2.4 info.
> thanks in advance.
> 

It depends on what FS you are using as well as if you are doing a
software or hardware RAID. With software on a Reiser or XFS it is very
very large. On hardware there is usually a controller limitation. I
currently have a 3TB partition with Reiser 3 in a RAID5 on a 3ware
9500S-12. However to get this size partition you have to use parted
instead of fdisk to create it. Otherwise the largest you will see is
700MB. 

Brad Dameron
SeaTab Software
www.seatab.com


