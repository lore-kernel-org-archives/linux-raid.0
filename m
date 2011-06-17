From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] gcc warnings again
Date: Fri, 17 Jun 2011 14:42:04 +1000
Message-ID: <20110617144204.28e651cb@notabene.brown>
References: <20110616070510.GA8544@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616070510.GA8544@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Jun 2011 09:05:10 +0200 Luca Berra <bluca@comedia.it> wrote:

> hello.
> yesterday i tried rebuilding both mdadm 3.1.5 and 3.2.1 with gcc 4.6,
> with the following CXFLAGS
> 
> x86:    -O2 -g -frecord-gcc-switches -Wstrict-aliasing=2 -pipe -Wformat
> -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector
> --param=ssp-buffer-size=4 -fomit-frame-pointer -mtune=generic
> -march=i586 -fasynchronous-unwind-tables
> 
> x86_64: -O2 -g -frecord-gcc-switches -Wstrict-aliasing=2 -pipe -Wformat
> -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector
> --param=ssp-buffer-size=4 -fPIC
> 
> i found a good number of warnings
> unused but set variable
> strict aliasing
> comparison between signed and unsigned values *on 32bit*
> 
> for the unused variables i found fedora already had a patch which is
> sensible enough, i did not see it reported here, so i will attach it.
> 
> I know -Wstrict-aliasing=2 can give false positive but those looked real
> to me, so i fixed those.
> 
> looking at the gpt code in util.c i found i did not like it at all, a
> gpt partition entry is currently 128 bytes, but the spec does not say it
> is a fixed value, so the code that reads into a buffer with 512bytes
> chunk expecting this to be a multiplier of part_size is imho incorrect.
> my fix was to read each partition entry directly into a struct
> GPT_part_entry, the advantage is that the code is very simple to read,
> the disadvantage it is 128 reads of 128 bytes each, which is
> sub-optimal, but i believe readahead will mitigate this a lot.
> 
> regards,
> L.
> 
> 

Hi Luca,
 thanks for these.  I have applied them all, though I made a number of
 changes to the first patch for fixing warning - nothing major.

They are just in time for 3.2.2 which is nice...

Thanks,
NeilBrown

