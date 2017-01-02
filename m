From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Using mdadm --grow to resize a RAID1
Date: Mon, 2 Jan 2017 12:19:27 +0000
Message-ID: <586A454F.1010308@youngman.org.uk>
References: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/01/17 10:18, Benjammin2068 wrote:
> I get stuck at the --size max.
> 
> it seems the correct syntax is "--size=" but that "max" is not supported as an argument.
> 
> little help?

Off the top of my head - try with no argument. iirc it defaults to max,
you don't need to tell it.

Cheers,
Wol
