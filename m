From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: md: persistent (file-backed) bitmap
Date: Wed, 10 Nov 2004 13:28:41 -0500
Message-ID: <41925DD9.4070704@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com>	<16590.38597.170409.499394@cse.unsw.edu.au>	<40D9FA9E.9010003@steeleye.com>	<40F7E50F.2040308@steeleye.com>	<16649.61212.310271.36561@cse.unsw.edu.au>	<4119400A.40307@steeleye.com>	<16668.12228.187383.596856@cse.unsw.edu.au>	<414F9FD4.4070308@steeleye.com>	<41507EA7.1000905@steeleye.com>	<16747.15933.68499.915859@cse.unsw.edu.au> <16785.25306.475922.200700@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16785.25306.475922.200700@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: jejb@steeleye.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Neil Brown wrote:

>  I would like to change the "RESYNC_MASK" bit to mean:
>    At least one block in this chunk is out-of-sync.

OK

>  Then:
>   - When we read the bitmap from disk we set this bit and the
>     SHADOW_MASK, but leave the counter at zero.
>   - When we get a failed write, we set this bit, but still decrement
>     the counter. 

>   - When we are performing a resync, we periodically clear the bit on
>     recently completed chunks.

I assume that this also means that the counter will get incremented 
before each read-for-resync is submitted. Perhaps you've already 
considered that?


>   - We only clear the SHADOW_MASK and on-disk bit when the counter
>     hits zero *and* this bit is clear.
> 
>  I would find this approach a lot easier to understand.  Are you OK
>  with it?

It sounds reasonable. Probably a little simpler too...

>  Also, I would like to move the bitmap_testbit in md_do_sync down into
>  the personality.  This should make life easier for other
>  personalities like raid10 which use a very different approach for
>  resync than for recovery.

OK, that sounds fine.

--
Paul
