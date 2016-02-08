From: "Maxin B. John" <maxin.john@gmail.com>
Subject: Re: [PATCH 2/3][mdadm] mdadm.h: bswap is already defined in uclibc
Date: Mon, 8 Feb 2016 18:10:29 +0200
Message-ID: <CAMhs6YwxytaKNJ-v9J714whBxgDxz_cQ9t8qi-wSp5Ho--vjfQ@mail.gmail.com>
References: <1454711298-32524-1-git-send-email-maxin.john@gmail.com>
	<1454711298-32524-2-git-send-email-maxin.john@gmail.com>
	<wrfjsi13dweh.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjsi13dweh.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

Hi Jes,

On Mon, Feb 8, 2016 at 6:00 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> "Maxin B. John" <maxin.john@gmail.com> writes:
>> From: "Maxin B. John" <maxin.john@intel.com>
>>
>> Fixes this build error:
>>
>> | In file included from mdadm.c:28:0:
>> | mdadm.h:142:0: error: "bswap_16" redefined [-Werror]
>> |  #define bswap_16(x) (((x) & 0x00ffU) << 8 | \
>> |  ^
>>
>> Signed-off-by: Maxin B. John <maxin.john@intel.com>
>> ---
>>  mdadm.h | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>
> Hi Maxin,
>
> I am not opposed to this, but I would like to understand why you see
> these duplicate defines. What defines it in your build environment?


I get the below listed error message with uclibc builds:

| x86_64-poky-linux-uclibc-gcc  -m64 -march=core2 -mtune=core2 -msse3
-mfpmath=sse --sysroot=/home/maxin/poky/build/tmp/sysroots/qemux86-64
-Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2
-pipe -g -feliminate-unused-debug-types -fno-strict-aliasing
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
 -DUSE_PTHREADS  -DBINDIR=\"/sbin\"  -c -o mdadm.o mdadm.c
| x86_64-poky-linux-uclibc-gcc  -m64 -march=core2 -mtune=core2 -msse3
-mfpmath=sse --sysroot=/home/maxin/poky/build/tmp/sysroots/qemux86-64
-Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2
-pipe -g -feliminate-unused-debug-types -fno-strict-aliasing
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
 -DUSE_PTHREADS  -DBINDIR=\"/sbin\"  -c -o config.o config.c
| x86_64-poky-linux-uclibc-gcc  -m64 -march=core2 -mtune=core2 -msse3
-mfpmath=sse --sysroot=/home/maxin/poky/build/tmp/sysroots/qemux86-64
-Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2
-pipe -g -feliminate-unused-debug-types -fno-strict-aliasing
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
 -DUSE_PTHREADS  -DBINDIR=\"/sbin\"  -c -o policy.o policy.c
| x86_64-poky-linux-uclibc-gcc  -m64 -march=core2 -mtune=core2 -msse3
-mfpmath=sse --sysroot=/home/maxin/poky/build/tmp/sysroots/qemux86-64
-Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2
-pipe -g -feliminate-unused-debug-types -fno-strict-aliasing
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
 -DUSE_PTHREADS  -DBINDIR=\"/sbin\"  -c -o mdstat.o mdstat.c
| x86_64-poky-linux-uclibc-gcc  -m64 -march=core2 -mtune=core2 -msse3
-mfpmath=sse --sysroot=/home/maxin/poky/build/tmp/sysroots/qemux86-64
-Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2
-pipe -g -feliminate-unused-debug-types -fno-strict-aliasing
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
 -DUSE_PTHREADS  -DBINDIR=\"/sbin\"  -c -o ReadMe.o ReadMe.c
| x86_64-poky-linux-uclibc-gcc  -m64 -march=core2 -mtune=core2 -msse3
-mfpmath=sse --sysroot=/home/maxin/poky/build/tmp/sysroots/qemux86-64
-Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2
-pipe -g -feliminate-unused-debug-types -fno-strict-aliasing
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
 -DUSE_PTHREADS  -DBINDIR=\"/sbin\"  -c -o util.o util.c
| x86_64-poky-linux-uclibc-gcc  -m64 -march=core2 -mtune=core2 -msse3
-mfpmath=sse --sysroot=/home/maxin/poky/build/tmp/sysroots/qemux86-64
-Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2
-pipe -g -feliminate-unused-debug-types -fno-strict-aliasing
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
 -DUSE_PTHREADS  -DBINDIR=\"/sbin\"  -c -o maps.o maps.c
| In file included from mdadm.c:28:0:
| mdadm.h:142:0: error: "bswap_16" redefined [-Werror]
|  #define bswap_16(x) (((x) & 0x00ffU) << 8 | \
|  ^
| In file included from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/endian.h:59:0,
|                  from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/sys/types.h:216,
|                  from mdadm.h:36,
|                  from mdadm.c:28:
| /home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/byteswap.h:29:0:
note: this is the location of the previous definition
|  #define bswap_16(x) __bswap_16 (x)
|  ^
| In file included from mdadm.c:28:0:
| mdadm.h:144:0: error: "bswap_32" redefined [-Werror]
|  #define bswap_32(x) (((x) & 0x000000ffU) << 24 | \
|  ^
| In file included from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/endian.h:59:0,
|                  from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/sys/types.h:216,
|                  from mdadm.h:36,
|                  from mdadm.c:28:
| /home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/byteswap.h:32:0:
note: this is the location of the previous definition
|  #define bswap_32(x) __bswap_32 (x)
|  ^
| In file included from mdadm.c:28:0:
| mdadm.h:148:0: error: "bswap_64" redefined [-Werror]
|  #define bswap_64(x) (((x) & 0x00000000000000ffULL) << 56 | \
|  ^
| In file included from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/endian.h:59:0,
|                  from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/sys/types.h:216,
|                  from mdadm.h:36,
|                  from mdadm.c:28:
| /home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/byteswap.h:36:0:
note: this is the location of the previous definition
|  # define bswap_64(x) __bswap_64 (x)
|  ^
| In file included from config.c:25:0:
| mdadm.h:142:0: error: "bswap_16" redefined [-Werror]
|  #define bswap_16(x) (((x) & 0x00ffU) << 8 | \
|  ^
| In file included from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/endian.h:59:0,
|                  from
/home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/sys/types.h:216,
|                  from mdadm.h:36,
|                  from config.c:25:
| /home/maxin/poky/build/tmp/sysroots/qemux86-64/usr/include/byteswap.h:29:0:
note: this is the location of the previous definition
|  #define bswap_16(x) __bswap_16 (x)
|  ^
......

> Jes

Best Regards,
Maxin

>>
>> diff --git a/mdadm.h b/mdadm.h
>> index dd02be7..230e60f 100755
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -139,12 +139,20 @@ struct dlm_lksb {
>>   * and there is no standard conversion function so... */
>>  /* And dietlibc doesn't think byteswap is ok, so.. */
>>  /*  #include <byteswap.h> */
>> +
>> +#ifndef bswap_16
>>  #define bswap_16(x) (((x) & 0x00ffU) << 8 | \
>>                    ((x) & 0xff00U) >> 8)
>> +#endif
>> +
>> +#ifndef bswap_32
>>  #define bswap_32(x) (((x) & 0x000000ffU) << 24 | \
>>                    ((x) & 0xff000000U) >> 24 | \
>>                    ((x) & 0x0000ff00U) << 8  | \
>>                    ((x) & 0x00ff0000U) >> 8)
>> +#endif
>> +
>> +#ifndef bswap_64
>>  #define bswap_64(x) (((x) & 0x00000000000000ffULL) << 56 | \
>>                    ((x) & 0xff00000000000000ULL) >> 56 | \
>>                    ((x) & 0x000000000000ff00ULL) << 40 | \
>> @@ -153,6 +161,7 @@ struct dlm_lksb {
>>                    ((x) & 0x0000ff0000000000ULL) >> 24 | \
>>                    ((x) & 0x00000000ff000000ULL) << 8 | \
>>                    ((x) & 0x000000ff00000000ULL) >> 8)
>> +#endif
>>
>>  #if !defined(__KLIBC__)
>>  #if BYTE_ORDER == LITTLE_ENDIAN
