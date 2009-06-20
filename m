From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: filesystem stripe parameters
Date: Sat, 20 Jun 2009 10:19:57 +0400
Message-ID: <4A3C7F8D.2090609@msgid.tls.msk.ru>
References: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com>	 <4A3B573D.5020206@msgid.tls.msk.ru> <7a329d910906191726k7acde13ye5f3b3c2e76c6692@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7a329d910906191726k7acde13ye5f3b3c2e76c6692@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wil Reichert <wil.reichert@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wil Reichert wrote:
> On Fri, Jun 19, 2009 at 2:15 AM, Michael Tokarev<mjt@tls.msk.ru> wrote:
[]
>> When everything is properly aligned, it's still worth the effort
>> IMHO to tell the filesystem about true raid properties.
> 
> Several questions answered, more questions arise =)
> 
> I'm using 3 1T discs, so it seems I'm in luck.  My chunk size is 128k,
> my PE size is the default 4M.  Using mkfs.ext4 as an example, it takes
> stride (chunk) and stripe-width ( chunk * (N-1) ) parameters.  So
> which would be optimal - using the RAID values (i.e. 128k, 256k) or
> the LVM values (i.e. 4M, 8M) when creating the filesystem or is there
> no right answer and it just depends on the usage pattern?

No, see my last statement from my initial email, quoted above.
Tell the fs about your raid.  If raid strips are combined using
some other way it's still raid and it's still strip size that
matters much.  After all, you need two parameters for the fs
(chunk + stripe-width) not one (lvm block size) -- this fact
already telling :)

/mjt
