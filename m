From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 6 reads all remaining chunks in a stripe when a single chunk
 is rewritten
Date: Tue, 17 Dec 2013 07:02:29 -0600
Message-ID: <52B04B65.7070603@hardwarefreak.com>
References: <52B02A08.4090007@informatik.uni-rostock.de>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B02A08.4090007@informatik.uni-rostock.de>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/17/2013 4:40 AM, Nikolaus Jeremic wrote:
> Hi,
> 
> I've did some Linux MD RAID 5 and 6 random write performance tests with
> fio 2.1.2 (Flexible I/O tester) under Linux 3.12.4. However, the results
> for RAID 6 show that writes to a single chunk in a stripe (chunk size is
> 64 KB) result in more than 3 reads in case of more than 6 drives (tested
> with 7, 8, and 9 drives) in the array (see fio statistics below). It
> seems like that in the event of updating one data chunk in a stripe, all
> of the remaining data chunks are read.
> 
> By the way, in case of RAID 5 and 5 or more drives, the remaining chunks
> seem not to be read when updating a single chunk in a stripe.
> 
> Here is the fio job description:

<snip>

It would be easier and more deterministic if you'd simply use dd to
write one full stripe, then seek to one chunk within that stripe and
write one page.

-- 
Stan
