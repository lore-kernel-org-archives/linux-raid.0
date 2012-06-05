From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 with two drive sizes question
Date: Tue, 05 Jun 2012 15:36:29 -0500
Message-ID: <4FCE6DCD.7030207@hardwarefreak.com>
References: <4FCE4199.7030705@gmx.net> <20120605233953.2086cc4c@natsu> <4FCE60F3.4040606@gmx.net> <20120606015950.585d5454@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120606015950.585d5454@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: "Joachim Otahal (privat)" <Jou@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/5/2012 2:59 PM, Roman Mamedov wrote:
> On Tue, 05 Jun 2012 21:41:39 +0200
> "Joachim Otahal (privat)" <Jou@gmx.net> wrote:
> 
>> Use only 750GB partitions, use the 3*250 GB loss at the end of each 1 TB 
>> drive for the fourth 750 GB, and RAID6 those 8*750. Result is 4.5 TB 
>> with a one-drive-loss tolerance and really bad performance.
>> I spare you the 500 GB partitions example which result in 4.5 TB with a 
>> one-drive-loss tolerance and really bad performance.
> 
> Except this would not make any sense even as a thought experiment. You don't
> want a configuration where two or more areas of the same physical disk need to
> be accessed in parallel for any read or write to the volume. And it's pretty
> easy to avoid that.

You make a good point but your backing argument is incorrect:  XFS by
design, by default, writes to 4 equal sized regions of a disk in parallel.

The problem here is running multiple RAID arrays, especially of
different RAID levels, on the same physical disk.  Under high IO load
you end up thrashing the heads due to excessive seeking as the access
patterns are very different between the arrays.  In some situations it
may not cause problems.  In others it can.

For a home type server with light IO load you probably won't have any
problems.  For anything with a high IO load, you don't want to do this
type of RAID setup.  Anyone with such an IO load already knows this,
which is why it's typically only hobbyists who would consider using such
a configuration.

-- 
Stan
