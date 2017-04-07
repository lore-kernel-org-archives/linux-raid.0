From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: mdadm:compiled warning in mdadm.c:1974:29 treats as errors
Date: Fri, 7 Apr 2017 10:53:41 -0400
Message-ID: <016b495a-1361-0f29-0fcb-6af008625565@gmail.com>
References: <F21EB93E-F788-4981-A8BD-7DA4AFC295F6@suse.com>
 <wrfjd1cqeugb.fsf@gmail.com> <0492b02e-1c4d-02e7-a196-f15e8684e4f3@suse.com>
 <a5f537c0-9b73-9a58-7566-0a242e0ff840@gmail.com>
 <87r315yupy.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r315yupy.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Liu Zhilong <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/06/2017 07:36 PM, NeilBrown wrote:
> On Thu, Apr 06 2017, Jes Sorensen wrote:
>
>> On 04/06/2017 04:21 AM, Liu Zhilong wrote:
>>> hi,
>>>
>>> I found this compiling warning, and can reproduce on my Leap42.1,
>>> Leap42.2 and SLES12 SP2 with v4.8.5 version of gcc.
>>>
>>> # gcc -v
>>> Using built-in specs.
>>> COLLECT_GCC=gcc
>>> COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-suse-linux/4.8/lto-wrapper
>>> Target: x86_64-suse-linux
>>> Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
>>> --mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
>>> --enable-languages=c,c++,objc,fortran,obj-c++,java,ada
>>> --enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.8
>>> --enable-ssp --disable-libssp --disable-plugin
>>> --with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux'
>>> --disable-libgcj --disable-libmudflap --with-slibdir=/lib64
>>> --with-system-zlib --enable-__cxa_atexit
>>> --enable-libstdcxx-allocator=new --disable-libstdcxx-pch
>>> --enable-version-specific-runtime-libs --enable-linker-build-id
>>> --enable-linux-futex --program-suffix=-4.8 --without-system-libunwind
>>> --with-arch-32=i586 --with-tune=generic --build=x86_64-suse-linux
>>> --host=x86_64-suse-linux
>>> Thread model: posix
>>> gcc version 4.8.5 (SUSE Linux)
>>>
>>> # make everything
>>> ... ...
>>> mdadm.c: In function ‘main’:
>>> mdadm.c:1974:29: error: ‘mdfd’ may be used uninitialized in this
>>> function [-Werror=maybe-uninitialized]
>>>    if (dv->devname[0] == '/' || mdfd < 0)
>>>                              ^
>>> mdadm.c:1914:7: note: ‘mdfd’ was declared here
>>>    int mdfd;
>>>        ^
>>> cc1: all warnings being treated as errors
>>> Makefile:206: recipe for target 'mdadm.Os' failed
>>> make: *** [mdadm.Os] Error 1
>>
>> Crappy compiler, you're running an old gcc. But sure, send me a patch
>> that initializes mdfd to -1.
>
> I would rather make the code more obviously correct.
>
> 		if (dv->devname[0] == '/' ||
> 		    (mdfd = open_dev(dv->devname)) < 0)
> 			mdfd = open_mddev(dv->devname, 1);
>
> well... it is more obvious to me.

I really don't like these convoluted if statements, especially the 
recursive assignment of mdfd here.

Cheers,
Jes


