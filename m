From: Zdenek Behan <rain@matfyz.cz>
Subject: Re: mdadm-3.1.1 segfaults when mdadm -G -Z
Date: Sun, 10 Jan 2010 14:47:33 +0100
Message-ID: <4B49DA75.8090404@matfyz.cz>
References: <4B49C47A.9060800@mejor.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B49C47A.9060800@mejor.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWFyY2luIE1pcm9zxYJhdw==?= <marcin@mejor.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/10/2010 01:13 PM, Marcin Miros=C5=82aw wrote:
> Hello,
> I tried to grow array size (i resized /dev/sdc5-> resync->remove
> /dev/sda6 -> resize /dev/sda6 -> resync-> curent situation )
> and i got segfault:
>
> # cat /proc/mdstat
> md6 : active raid1 sdc5[1](W) sda7[0]
>       125001664 blocks [2/2] [UU]
>       bitmap: 16/239 pages [64KB], 256KB chunk
>
> # gdb /sbin/mdadm
> [...]
> <http://bugs.gentoo.org/>...
> Reading symbols from
> /var/tmp/portage/sys-fs/mdadm-3.1.1/work/mdadm-3.1.1/mdadm...done.
> (gdb) run  -G -Z /dev/md6
> Starting program:
> /var/tmp/portage/sys-fs/mdadm-3.1.1/work/mdadm-3.1.1/mdadm -G -Z /dev=
/md6
>
> Program received signal SIGSEGV, Segmentation fault.
> 0xb7f067f8 in strcmp () from /lib/libc.so.6
> (gdb) bt
> #0  0xb7f067f8 in strcmp () from /lib/libc.so.6
> #1  0x0804b70b in main (argc=3D4, argv=3D0xbffff3f4) at mdadm.c:408
> (gdb)
>
> $  uname -r
> 2.6.32-gentoo-r1
>
> May i get any suggestions?
> Regards
>  =20
       -Z, --array-size=3D
              This is only meaningful with --grow and its effect is=20
not  per=E2=80=90
              sistent:  when  the  array  is  stopped an restarted the
default
              array size will be restored.

You didn't supply any argument to -Z at all, or to be precise, you
supplied /dev/md6 as the argument, whereas you should have put in the
array size.

Also, another thing I have noticed lately is, that _some_ short options
seem to be somehow oddly broken on my system and not accepting
arguments, even if they are supposed to be. If the segfault persists
after using the correct syntax, try using the long opts instead. I was
planning to dig more into this bug myself, so I might just kick self to
do it now.


Zdenek
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
