From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Write intent bitmaps
Date: Sun, 21 Jun 2009 14:06:21 -0400
Message-ID: <4A3E769D.7060207@tmr.com>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>	<18989.6010.582386.812296@fisica.ufpr.br> <19002.62697.475588.28776@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19002.62697.475588.28776@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday June 8, carlos@fisica.ufpr.br wrote:
>   
>>  >5. What happens if the bitmap is lost or the external drive fills up?
>>
>> No idea.
>>     
>
> If the bitmap is lost, it is just as though you didn't have a bitmap 
> (or as though all the bits in the bitmap were set to one).
>
> The drive filling up is not relevant.  When the bitmap is in a
> separate file, the file is preallocated to be the right size.
>
>   
>>  >If so, would ext2 probably be the best choice?
>>
>> That's what the man page says. I find it strange since if it's a file
>> the filesystem shouldn't matter. Neil?
>>     
>
> The way that md writes to the bitmap file is not entirely portable
> across different filesystems.  As the man page say,  it is known to
> work for ext2 and ext3.  Either is a fine choice.
> A new filesystem interface is being introduced in 2.6.31 as part of
> the swap-over-NFS work.  I might end up using that to write to bitmap
> files, as it has the right characteristics.  But that is very much in
> the future.
>   

I never understood why swap over anything wasn't supported... we had 
swap over NFS in SunOS, in 1992, and that was over 10Mbit thicknet to 
drives sized in MB (RAM in MB, too). I have been trying some things with 
SSD, putting swap on it, bitmaps both raid and f/s, and journals. At the 
moment I'm developing the scripts and tools to do valid measurement.

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

