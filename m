From: Ari Pollak <ari@debian.org>
Subject: Re: Invalid argument when creating a RAID-0 array
Date: Sat, 14 Jun 2003 19:04:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EEBA9F2.7060902@debian.org>
References: <3EEB36DA.6050407@debian.org> <16107.43382.98190.258955@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16107.43382.98190.258955@gargle.gargle.HOWL>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>[Please CC me on replies]

>>too small chunk_size: 4096 < 8192
> 
> 
> Maybe use a bigger chunk size, 4K is rather small.
> However I thought 4k would work.  Maybe you aren't using an i386, as
> the minimum chunksize is currently connected with the system
> pagesize.  What architecture are you using?

Oops, I forgot to specify. I'm using an UltraSPARC on a Sun Enterprise 
450, using kernel 2.4.19 (I haven't had a chance to try .21 yet). I was 
just following the Software-RAID HOWTO, which said that for striping, 
chunksize didn't really matter.

