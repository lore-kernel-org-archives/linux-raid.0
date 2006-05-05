From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Two-disk RAID5?
Date: Thu, 04 May 2006 21:22:29 -0400
Message-ID: <445AA8D5.2040604@tmr.com>
References: <1146069707.10253.50.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1146069707.10253.50.camel@kenny>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Rowe wrote:

>I'm about to create a RAID1 file system and a strange thought occurs to
>me: if I create a two-disk RAID5 array then I can grow it later by the
>simple expedient of adding a third disk and hence doubling its size.
>
>Is there any real down-side to this, such as performance? Alternatively
>is it likely that mdadm will soon be able to convert a RAID1 pair to
>RAID5 any time soon? (Just how different are they anyway? Isn't the
>RAID4/5 checksum just an OR?)
>
I think it works, I just set up a little test case with two 20MB files 
and loopback mount. The mdadm seems to work, the mke2fs seems to work, 
the f/s is there. Please verify, this system is a bit (okay a bunch) hacked.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

