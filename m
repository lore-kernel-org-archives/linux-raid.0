From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: Re: alignment of metadata 1.2 and mkfs.ext4
Date: Wed, 06 Jul 2011 10:52:34 +0100
Message-ID: <1309945954.2685.2.camel@baal>
References: <1309936276.11661.8.camel@baal>  <20110706152016.1982c6fd@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110706152016.1982c6fd@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2011-07-06 at 15:20 +0600, Roman Mamedov wrote:
> On Wed, 06 Jul 2011 08:11:16 +0100
> "Tyler J. Wagner" <tyler@tolaris.com> wrote:
> 
> > Metadata 1.2 puts the data 4K from the start of the device/partition.
> 
> This is not correct. See mdadm -E /dev/sdX.
> 
> $ sudo mdadm -E /dev/sdc3
> /dev/sdc3:
> ...
>         Version : 1.2
> ...
>     Data Offset : 2048 sectors
> ...

That is very interesting. The mdadm man page, and everything I've seen
online, all say "The different sub-versions store the superblock at
different locations on the device, either at the end (for 1.0), at the
start (for 1.1) or 4K from the start (for 1.2)."

Regards,
Tyler

-- 
"Religion is the opiate of the masses, so long as the masses are straight. 
However, amass a bunch of lesbians and you're going to need actual drugs."
   -- OKCupid Blog, with apologies to Karl Marx
      http://blog.okcupid.com/index.php/gay-sex-vs-straight-sex/

