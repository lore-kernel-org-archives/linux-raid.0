From: "Vladimir I. Umnov" <uvi@ezmail.ru>
Subject: Re: Low perfomance of RAID0,RAID5, RAID+LVM on 2.6
Date: Fri, 20 Aug 2004 20:11:37 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040820201137.2ee99a14@vovapc.kpml.int>
References: <8075D5C3061B9441944E1373776451186488C7@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E1373776451186488C7@cinshrexc03.shermfin.com>
To: "Rechenberg, Andrew" <ARechenberg@sfg.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Aug 2004 14:12:07 -0400
"Rechenberg, Andrew" <ARechenberg@sfg.com> wrote:

> In the part of the message that was quoted to the linux-raid list the
> performance of the RAID devices isn't specified.  All I see is you
> testing /dev/sda1 and mentioning kernel modules, but no mention of
> /dev/mdX or /dev/YourVG/YourLV.
It was my reply to answer, tests with md and lvm was in first message
to this linux-raid lisst.

And setting readahead on lvm volumes helpes. Now I get about 80 Mb/s
read on raid5 and about 100Mb/s on raid0, but the cpu overhead was very
high, but acceptable  for me. But it helps only in 2.6.6! 2.6.7 and
2.6.8.1 much slower than 2.6.6.


