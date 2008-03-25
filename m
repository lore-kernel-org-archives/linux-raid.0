From: "David Rees" <drees76@gmail.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Tue, 25 Mar 2008 15:13:35 -0700
Message-ID: <72dbd3150803251513v28ea142ct2de229c26e888c56@mail.gmail.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 25, 2008 at 2:33 PM, Christian Pernegger
<pernegger@gmail.com> wrote:
>  So I ran the same tests using a md-raid5 over the same disks just for
>  kicks (512KB chunks, no bitmap):
>
>  dd-reads: 115 MB/s
>  bonnie++-reads: 87  MB/s
>  dd-writes: 69 MB/s
>  bonnie++-writes: 62  MB/s
>
>  Writes are actually a lot better than any raid10 ... despite all the
>  hype it gets on the list. I wanted to go with raid10 for this box
>  because it's not mostly-read for a change.

Not surprising at all. Read performance is similar between the two
setups as expected (appears to be limited by the PCI bus).

Streaming write performance is better because you are writing less
redundant data to disks, you can now stripe writes over 5 disks
instead of 3. So your performance increase there also looks
appropriate.

Your benchmarks are simulating the best case scenario for RAID5.

-Dave
