From: Liu Zhilong <zlliu@suse.com>
Subject: Re: mdadm:compiled warning in mdadm.c:1974:29 treats as errors
Date: Thu, 6 Apr 2017 16:21:51 +0800
Message-ID: <0492b02e-1c4d-02e7-a196-f15e8684e4f3@suse.com>
References: <F21EB93E-F788-4981-A8BD-7DA4AFC295F6@suse.com>
 <wrfjd1cqeugb.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjd1cqeugb.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

I found this compiling warning, and can reproduce on my Leap42.1, 
Leap42.2 and SLES12 SP2 with v4.8.5 version of gcc.

# gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-suse-linux/4.8/lto-wrapper
Target: x86_64-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info 
--mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64 
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada 
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.8 
--enable-ssp --disable-libssp --disable-plugin 
--with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux' 
--disable-libgcj --disable-libmudflap --with-slibdir=/lib64 
--with-system-zlib --enable-__cxa_atexit 
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch 
--enable-version-specific-runtime-libs --enable-linker-build-id 
--enable-linux-futex --program-suffix=-4.8 --without-system-libunwind 
--with-arch-32=i586 --with-tune=generic --build=x86_64-suse-linux 
--host=x86_64-suse-linux
Thread model: posix
gcc version 4.8.5 (SUSE Linux)

# make everything
... ...
mdadm.c: In function ‘main’:
mdadm.c:1974:29: error: ‘mdfd’ may be used uninitialized in this 
function [-Werror=maybe-uninitialized]
    if (dv->devname[0] == '/' || mdfd < 0)
                              ^
mdadm.c:1914:7: note: ‘mdfd’ was declared here
    int mdfd;
        ^
cc1: all warnings being treated as errors
Makefile:206: recipe for target 'mdadm.Os' failed
make: *** [mdadm.Os] Error 1

Thanks,
-Zhilong

On 04/05/2017 11:37 PM, jes.sorensen@gmail.com wrote:
> Zhilong <zlliu@suse.com> writes:
>> Hi,jes;
>>    I have found that there is mdfd returns uninitialized warning in
>> mdadm.c. I cannot paste the logs due to I'm on holiday. Please try to
>> issue make everything, you should see it.
> I don't see anything here, if you have specifics, please post them.
>
> Jes

