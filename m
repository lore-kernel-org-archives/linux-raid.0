From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: OOPS in do_try_to_free_pages with VERY large software RAID array
Date: Tue, 11 Mar 2003 15:18:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E1373776451180F076E@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C2E80B.55D5283A"
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C2E80B.55D5283A
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

With the help of Martin Bligh, Kevin Fleming, and Randy Dunlap, it looks
like this problem is related to the large size of the information
presented in /proc/mdstat and it overflowing the 4k page boundary.

With Kevin's patch from last week and some help from Randy, I patched
the md code in Red Hat 2.4.18-26.7.x to use the seq_file interface for
mdstat.  I've attached the patch.  As with Kevin's patch, it touches
almost everything in drivers/md, as well as adding the necessary methods
to fs/seq_file.c and include/linux/seq_file.h.

I'm currently testing raid1 and raid0 and it seems to work well.  No
panics yet!!! :)  I currently have 26 RAID1 arrays and a big RAID0
stripe across that and I'm running some I/O tests on it now to make sure
that it is stable. =20

I haven't tested the raid5, linear, or multipath code, so someone might
want to test that out before using it in production :)

As Kevin indicated in his mail, I can post the patch to a web site if
attachments are a problem.

Thanks to everyone for their help.

Regards,
Andy.


-----Original Message-----
From: Rechenberg, Andrew=20
Sent: Monday, March 10, 2003 2:19 PM
To: linux-kernel!@vger.kernel.org; linux-raid@vger.kernel.org
Subject: OOPS in do_try_to_free_pages with VERY large software RAID
array


Good day.

Can anyone help me out please?  I'm trying to create a monster software
RAID array and the kernel is not behaving.  On some test hardware I can
get 17 RAID1 arrays to begin syncing and will sync with
/proc/sys/dev/raid/speed_limit_max set to 100000 (the max allowed) with
no problem. =20

We wanted to use 26 RAID1 arrays and then stripe across them to get very
high performance.  When I tried to do that this weekend on our
production box we started getting kernel panics when the RAID1 arrays
started syncing.  This was with speed_limit_max set to 10000 so the rate
wasn't very high.  Since we knew 34 disks worked we decided to put the
box in to production with just 13 RAID1 arrays and striping across
those.  The performance is great compared to our hardware RAID, but I
would like to get all the disks we purchase for this system working.

This morning I connected 56 disks to our test hardware and tried to
reproduce the problem.  With the test hardware, the 26 RAID1 arrays were
working OK at speed_limit_max 10000 however the kernel OOPSed when I
'less'ed /proc/mdstat.  It wasn't a hard crash because I could still
work.  However when I upped the speed_limit_max to 30000 there was a
hard crash.

I've tried disabling Hyper Threading on these boxes with the 'noht'
kernel boot parameter, but that didn't seem to help.  A lot of what's on
Google points to bad hardware, but I don't think this problem is
hardware-related.  The kernels are stock Red Hat source and have
CONFIG_SD_EXTRA_DEVS set to 64 and have the megaraid2 module patches.

The output from ksymoops for both OOPS are below along with the
production and test hardware specs and kernel versions.  If anyone can
aid me, please let me know.  This is test hardware so I an free to try
kernel patches or anything else.  If more information is needed please
let me know.  I am subscribed to the RAID list, but not to the LKML so
please CC: me with responses.

Thank you so much for your assistance,
Andy.

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group


Production Hardware
--------------------
Dell PE6600
4x1.4GHz Xeon with HT
8GB RAM
2.4.18-19.7.xbigmem-SHR
ProductionHW Modules:
---------------------
Module                  Size  Used by    Not tainted
lp                      8672   0  (autoclean)
parport                35648   0  (autoclean) [lp]
autofs                 11620   0  (autoclean) (unused)
tg3                    47200   1
raid0                   4128   1  (autoclean)
raid1                  15556  13  (autoclean)
loop                   11184   0  (autoclean)
lvm-mod                64608   3
ext3                   67360   7
jbd                    51464   7  [ext3]
aic7xxx               153664  28
megaraid2              37920   7
sd_mod                 12800  70
scsi_mod              110352   3  [aic7xxx megaraid2 sd_mod]

Test Hardware
-------------
Dell PE4600
2x2.4GHz Xeon with HT
4GB RAM
2.4.18-24.7.xbigmem-SHR (includes megaraid2 module)
TestHW Modules
---------------
Module                  Size  Used by    Not tainted
e100                   58500   1
raid1                  15556   0  (autoclean)
loop                   11184   0  (autoclean)
sr_mod                 16088   0  (autoclean) (unused)
cdrom                  32416   0  (autoclean) [sr_mod]
usb-ohci               21856   0  (unused)
usbcore                74400   1  [usb-ohci]
lvm-mod                64608   0
aic7xxx               129856   3
sd_mod                 12832   6
scsi_mod              110800   3  [sr_mod aic7xxx sd_mod]

[root@cinshrinft1 ~]# ksymoops -k /proc/ksyms /tmp/raidoops ksymoops
2.4.4 on i686 2.4.18-24.7.xbigmem-SHR.  Options used
     -V (default)
     -k /proc/ksyms (specified)
     -l /proc/modules (default)
     -o /lib/modules/2.4.18-24.7.xbigmem-SHR/ (default)
     -m /boot/System.map-2.4.18-24.7.xbigmem-SHR (default)

Error (expand_objects): cannot stat(/lib/lvm-mod.o) for lvm-mod
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/lib/aic7xxx.o) for aic7xxx
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/lib/sd_mod.o) for sd_mod
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/lib/scsi_mod.o) for scsi_mod
ksymoops: No such file or directory
OOPS: 0000
CPU: 3
EIP: 0010 [<c0138320>] Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010883
eax: 5d305b21  ebx: 000000a3  ecx: 00000006  edx: c5e8a090
esi: c5e8a080  edi: 00000000  ebp: c5e5e2b4  esp: f7ffdf64
ds: 0018   es: 0018   ss: 0018
Call Trace: [<c013aa8e>] do_try_to_free_pages [kernel] 0x3e
(0xf7ffdf98))
[<c013add1>] kswapd [kernel] 0x141 (0xf7ffdfd4))
[<c0105000>] stext [kernel] 0x0 (0xf7ffdfe8))
[<c01072a6>] kernel_thread [kernel] 0x26 (0xf7ffdff0)) [<c013ac90>]
kswapd [kernel] 0x0 (0xf7ffdff8))
Code: 8b 00 43 39 d0 75 f9 8b 4e 3c 89 da 8b 7e 4c d3 e2 85 ff 74

>>EIP; c0138320 <kmem_cache_reap+1d0/340>   <=3D=3D=3D=3D=3D
Trace; c013aa8e <do_try_to_free_pages+3e/1b0>
Trace; c013add1 <kswapd+141/390>
Trace; c0105000 <_stext+0/0>
Trace; c01072a6 <kernel_thread+26/30>
Trace; c013ac90 <kswapd+0/390>
Code;  c0138320 <kmem_cache_reap+1d0/340>
00000000 <_EIP>:
Code;  c0138320 <kmem_cache_reap+1d0/340>   <=3D=3D=3D=3D=3D
   0:   8b 00                     mov    (%eax),%eax   <=3D=3D=3D=3D=3D
Code;  c0138322 <kmem_cache_reap+1d2/340>
   2:   43                        inc    %ebx
Code;  c0138323 <kmem_cache_reap+1d3/340>
   3:   39 d0                     cmp    %edx,%eax
Code;  c0138325 <kmem_cache_reap+1d5/340>
   5:   75 f9                     jne    0 <_EIP>
Code;  c0138327 <kmem_cache_reap+1d7/340>
   7:   8b 4e 3c                  mov    0x3c(%esi),%ecx
Code;  c013832a <kmem_cache_reap+1da/340>
   a:   89 da                     mov    %ebx,%edx
Code;  c013832c <kmem_cache_reap+1dc/340>
   c:   8b 7e 4c                  mov    0x4c(%esi),%edi
Code;  c013832f <kmem_cache_reap+1df/340>
   f:   d3 e2                     shl    %cl,%edx
Code;  c0138331 <kmem_cache_reap+1e1/340>
  11:   85 ff                     test   %edi,%edi
Code;  c0138333 <kmem_cache_reap+1e3/340>
  13:   74 00                     je     15 <_EIP+0x15> c0138335
<kmem_cache_reap+1e5/340>


4 errors issued.  Results may not be reliable.


[root@cinshrinft1 ~]# ksymoops -k /proc/ksyms /tmp/lessoops ksymoops
2.4.4 on i686 2.4.18-24.7.xbigmem-SHR.  Options used
     -V (default)
     -k /proc/ksyms (specified)
     -l /proc/modules (default)
     -o /lib/modules/2.4.18-24.7.xbigmem-SHR/ (default)
     -m /boot/System.map-2.4.18-24.7.xbigmem-SHR (default)

Error (expand_objects): cannot stat(/lib/lvm-mod.o) for lvm-mod
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/lib/aic7xxx.o) for aic7xxx
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/lib/sd_mod.o) for sd_mod
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/lib/scsi_mod.o) for scsi_mod
ksymoops: No such file or directory
Mar 10 09:56:03 cinshrinft1 kernel: Unable to handle kernel paging
request at virtual address 0a5d306f Mar 10 09:56:03 cinshrinft1 kernel:
c0145084 Mar 10 09:56:03 cinshrinft1 kernel: *pde =3D 00000000 Mar 10
09:56:03 cinshrinft1 kernel: Oops: 0002
Mar 10 09:56:03 cinshrinft1 kernel: CPU:    3
Mar 10 09:56:03 cinshrinft1 kernel: EIP:    0010:[<c0145084>]    Not
tainted
Using defaults from ksymoops -t elf32-i386 -a i386
Mar 10 09:56:03 cinshrinft1 kernel: EFLAGS: 00010202
Mar 10 09:56:03 cinshrinft1 kernel: eax: 0a5d305b   ebx: eba14c80   ecx:
00000001   edx: eba14c80
Mar 10 09:56:03 cinshrinft1 kernel: esi: 0805db40   edi: fffffff7   ebp:
000003eb   esp: eb7d3f88
Mar 10 09:56:03 cinshrinft1 kernel: ds: 0018   es: 0018   ss: 0018
Mar 10 09:56:03 cinshrinft1 kernel: Process less (pid: 6866,
stackpage=3Deb7d3000)
Mar 10 09:56:03 cinshrinft1 kernel: Stack: eb7d2000 c01440f9 0000000c
00000003 c0116a29 00000001 0805db40 c0121
Mar 10 09:56:03 cinshrinft1 kernel:        eb7d3fac 3e6ca782 eb7d2000
0805db40 00000000 bfffe438 c0108c93 00000
Mar 10 09:56:03 cinshrinft1 kernel:        0805e540 000003eb 0805db40
00000000 bfffe438 00000004 0000002b 00000
Mar 10 09:56:03 cinshrinft1 kernel: Call Trace: [<c01440f9>] sys_write
[kernel] 0x19 (0xeb7d3f8c)) Mar 10 09:56:03 cinshrinft1 kernel:
[<c0116a29>] smp_apic_timer_interrupt [kernel] 0xa9 (0xeb7d3f98)) Mar 10
09:56:03 cinshrinft1 kernel: [<c0121e52>] sys_time [kernel] 0x12
(0xeb7d3fa4))
Mar 10 09:56:03 cinshrinft1 kernel: [<c0108c93>] system_call [kernel]
0x33 (0xeb7d3fc0)) Mar 10 09:56:03 cinshrinft1 kernel: Code: f0 ff 40 14
f0 ff 43 04 5b c3 89 f6 8b 4c 24 04 f0 ff 49 14

>>EIP; c0145084 <fget+34/40>   <=3D=3D=3D=3D=3D
Trace; c01440f9 <sys_write+19/110>
Trace; c0116a29 <smp_apic_timer_interrupt+a9/d0>
Trace; c0121e52 <sys_time+12/60>
Trace; c0108c93 <system_call+33/38>
Code;  c0145084 <fget+34/40>
00000000 <_EIP>:
Code;  c0145084 <fget+34/40>   <=3D=3D=3D=3D=3D
   0:   f0 ff 40 14               lock incl 0x14(%eax)   =
<=3D=3D=3D=3D=3D
Code;  c0145088 <fget+38/40>
   4:   f0 ff 43 04               lock incl 0x4(%ebx)
Code;  c014508c <fget+3c/40>
   8:   5b                        pop    %ebx
Code;  c014508d <fget+3d/40>
   9:   c3                        ret
Code;  c014508e <fget+3e/40>
   a:   89 f6                     mov    %esi,%esi
Code;  c0145090 <put_filp+0/50>
   c:   8b 4c 24 04               mov    0x4(%esp,1),%ecx
Code;  c0145094 <put_filp+4/50>
  10:   f0 ff 49 14               lock decl 0x14(%ecx)


4 errors issued.  Results may not be reliable.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

------_=_NextPart_001_01C2E80B.55D5283A
Content-Type: application/octet-stream;
	name="md-seq_file-2.4.18-26.7.x.patch"
Content-Transfer-Encoding: base64
Content-Description: md-seq_file-2.4.18-26.7.x.patch
Content-Disposition: attachment;
	filename="md-seq_file-2.4.18-26.7.x.patch"

LS0tIC4uL2xpbnV4LTIuNC4xOC0yNi43LngvZHJpdmVycy9tZC9saW5lYXIuYwlTdW4gU2VwIDMw
IDE1OjI2OjA2IDIwMDEKKysrIC4vZHJpdmVycy9tZC9saW5lYXIuYwlUdWUgTWFyIDExIDExOjA5
OjA0IDIwMDMKQEAgLTIyLDYgKzIyLDcgQEAKICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiAKICNp
bmNsdWRlIDxsaW51eC9yYWlkL2xpbmVhci5oPgorI2luY2x1ZGUgPGxpbnV4L3NlcV9maWxlLmg+
CiAKICNkZWZpbmUgTUFKT1JfTlIgTURfTUFKT1IKICNkZWZpbmUgTURfRFJJVkVSCkBAIC0xNTMs
MzEgKzE1NCwyOSBAQAogCXJldHVybiAxOwogfQogCi1zdGF0aWMgaW50IGxpbmVhcl9zdGF0dXMg
KGNoYXIgKnBhZ2UsIG1kZGV2X3QgKm1kZGV2KQorc3RhdGljIHZvaWQgbGluZWFyX3N0YXR1cyAo
c3RydWN0IHNlcV9maWxlICpzZXEsIG1kZGV2X3QgKm1kZGV2KQogewotCWludCBzeiA9IDA7CiAK
ICN1bmRlZiBNRF9ERUJVRwogI2lmZGVmIE1EX0RFQlVHCiAJaW50IGo7CiAJbGluZWFyX2NvbmZf
dCAqY29uZiA9IG1kZGV2X3RvX2NvbmYobWRkZXYpOwogICAKLQlzeiArPSBzcHJpbnRmKHBhZ2Ur
c3osICIgICAgICAiKTsKKwlzZXFfcHJpbnRmKHNlcSwgIiAgICAgICIpOwogCWZvciAoaiA9IDA7
IGogPCBjb25mLT5ucl96b25lczsgaisrKQogCXsKLQkJc3ogKz0gc3ByaW50ZihwYWdlK3N6LCAi
WyVzIiwKKwkJc2VxX3ByaW50ZihzZXEsICJbJXMiLAogCQkJcGFydGl0aW9uX25hbWUoY29uZi0+
aGFzaF90YWJsZVtqXS5kZXYwLT5kZXYpKTsKIAogCQlpZiAoY29uZi0+aGFzaF90YWJsZVtqXS5k
ZXYxKQotCQkJc3ogKz0gc3ByaW50ZihwYWdlK3N6LCAiLyVzXSAiLAorCQkJc2VxX3ByaW50Zihz
ZXEsICIvJXNdICIsCiAJCQkgIHBhcnRpdGlvbl9uYW1lKGNvbmYtPmhhc2hfdGFibGVbal0uZGV2
MS0+ZGV2KSk7CiAJCWVsc2UKLQkJCXN6ICs9IHNwcmludGYocGFnZStzeiwgIl0gIik7CisJCQlz
ZXFfcHJpbnRmKHNlcSwgIl0gIik7CiAJfQotCXN6ICs9IHNwcmludGYocGFnZStzeiwgIlxuIik7
CisJc2VxX3ByaW50ZihzZXEsICJcbiIpOwogI2VuZGlmCi0Jc3ogKz0gc3ByaW50ZihwYWdlK3N6
LCAiICVkayByb3VuZGluZyIsIG1kZGV2LT5wYXJhbS5jaHVua19zaXplLzEwMjQpOwotCXJldHVy
biBzejsKKwlzZXFfcHJpbnRmKHNlcSwgIiAlZGsgcm91bmRpbmciLCBtZGRldi0+cGFyYW0uY2h1
bmtfc2l6ZS8xMDI0KTsKIH0KIAogCi0tLSAuLi9saW51eC0yLjQuMTgtMjYuNy54L2RyaXZlcnMv
bWQvbWQuYwlNb24gRmViIDI0IDA5OjE1OjM5IDIwMDMKKysrIC4vZHJpdmVycy9tZC9tZC5jCVR1
ZSBNYXIgMTEgMTI6MjU6NDYgMjAwMwpAQCAtMzYsNiArMzYsOCBAQAogI2luY2x1ZGUgPGxpbnV4
L2RldmZzX2ZzX2tlcm5lbC5oPgogCiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPgorI2luY2x1ZGUg
PGxpbnV4L3Byb2NfZnMuaD4KKyNpbmNsdWRlIDxsaW51eC9zZXFfZmlsZS5oPgogCiAjaWZkZWYg
Q09ORklHX0tNT0QKICNpbmNsdWRlIDxsaW51eC9rbW9kLmg+CkBAIC0xMjgsNiArMTMwLDE1IEBA
CiAJZm9wczogJm1kX2ZvcHMsCiB9OwogCitzdGF0aWMgaW50IG1kX3N0YXRlX29wZW5fZnMoc3Ry
dWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpOworCitzdGF0aWMgc3RydWN0IGZp
bGVfb3BlcmF0aW9ucyBtZF9zdGF0ZV9mb3BzID0geworCW9wZW46IG1kX3N0YXRlX29wZW5fZnMs
CisJcmVhZDogc2VxX3JlYWQsCisJbGxzZWVrOiBzZXFfbHNlZWssCisJcmVsZWFzZTogc2luZ2xl
X3JlbGVhc2UsCit9OworCiAvKgogICogRW5hYmxlcyB0byBpdGVyYXRlIG92ZXIgYWxsIGV4aXN0
aW5nIG1kIGFycmF5cwogICovCkBAIC0zMDcwLDEzICszMDgxLDEzIEBACiAJcmV0dXJuIDA7CiB9
CiAKLXN0YXRpYyBpbnQgc3RhdHVzX3VudXNlZChjaGFyICogcGFnZSkKK3N0YXRpYyB2b2lkIHN0
YXR1c191bnVzZWQoc3RydWN0IHNlcV9maWxlICogc2VxKQogewotCWludCBzeiA9IDAsIGkgPSAw
OworCWludCBpID0gMDsKIAltZGtfcmRldl90ICpyZGV2OwogCXN0cnVjdCBtZF9saXN0X2hlYWQg
KnRtcDsKIAotCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAidW51c2VkIGRldmljZXM6ICIpOwor
CXNlcV9wcmludGYoc2VxLCAidW51c2VkIGRldmljZXM6ICIpOwogCiAJSVRFUkFURV9SREVWX0FM
TChyZGV2LHRtcCkgewogCQlpZiAoIXJkZXYtPnNhbWVfc2V0Lm5leHQgJiYgIXJkZXYtPnNhbWVf
c2V0LnByZXYpIHsKQEAgLTMwODQsMjEgKzMwOTUsMTkgQEAKIAkJCSAqIFRoZSBkZXZpY2UgaXMg
bm90IHlldCB1c2VkIGJ5IGFueSBhcnJheS4KIAkJCSAqLwogCQkJaSsrOwotCQkJc3ogKz0gc3By
aW50ZihwYWdlICsgc3osICIlcyAiLAorCQkJc2VxX3ByaW50ZihzZXEsICIlcyAiLAogCQkJCXBh
cnRpdGlvbl9uYW1lKHJkZXYtPmRldikpOwogCQl9CiAJfQogCWlmICghaSkKLQkJc3ogKz0gc3By
aW50ZihwYWdlICsgc3osICI8bm9uZT4iKTsKKwkJc2VxX3ByaW50ZihzZXEsICI8bm9uZT4iKTsK
IAotCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAiXG4iKTsKLQlyZXR1cm4gc3o7CisJc2VxX3By
aW50ZihzZXEsICJcbiIpOwogfQogCiAKLXN0YXRpYyBpbnQgc3RhdHVzX3Jlc3luYyhjaGFyICog
cGFnZSwgbWRkZXZfdCAqIG1kZGV2KQorc3RhdGljIHZvaWQgc3RhdHVzX3Jlc3luYyhzdHJ1Y3Qg
c2VxX2ZpbGUgKiBzZXEsIG1kZGV2X3QgKiBtZGRldikKIHsKLQlpbnQgc3ogPSAwOwogCXVuc2ln
bmVkIGxvbmcgbWF4X2Jsb2NrcywgcmVzeW5jLCByZXMsIGR0LCBkYiwgcnQ7CiAKIAlyZXN5bmMg
PSAobWRkZXYtPmN1cnJfcmVzeW5jIC0gYXRvbWljX3JlYWQoJm1kZGV2LT5yZWNvdmVyeV9hY3Rp
dmUpKS8yOwpAQCAtMzEwOSwzMCArMzExOCwyOSBAQAogCSAqLwogCWlmICghbWF4X2Jsb2Nrcykg
ewogCQlNRF9CVUcoKTsKLQkJcmV0dXJuIDA7CiAJfQogCXJlcyA9IChyZXN5bmMvMTAyNCkqMTAw
MC8obWF4X2Jsb2Nrcy8xMDI0ICsgMSk7CiAJewogCQlpbnQgaSwgeCA9IHJlcy81MCwgeSA9IDIw
LXg7Ci0JCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAiWyIpOworCQlzZXFfcHJpbnRmKHNlcSwg
IlsiKTsKIAkJZm9yIChpID0gMDsgaSA8IHg7IGkrKykKLQkJCXN6ICs9IHNwcmludGYocGFnZSAr
IHN6LCAiPSIpOwotCQlzeiArPSBzcHJpbnRmKHBhZ2UgKyBzeiwgIj4iKTsKKwkJCXNlcV9wcmlu
dGYoc2VxLCAiPSIpOworCQlzZXFfcHJpbnRmKHNlcSwgIj4iKTsKIAkJZm9yIChpID0gMDsgaSA8
IHk7IGkrKykKLQkJCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAiLiIpOwotCQlzeiArPSBzcHJp
bnRmKHBhZ2UgKyBzeiwgIl0gIik7CisJCQlzZXFfcHJpbnRmKHNlcSwgIi4iKTsKKwkJc2VxX3By
aW50ZihzZXEsICJdICIpOwogCX0KIAlpZiAoIW1kZGV2LT5yZWNvdmVyeV9ydW5uaW5nKQogCQkv
KgogCQkgKiB0cnVlIHJlc3luYwogCQkgKi8KLQkJc3ogKz0gc3ByaW50ZihwYWdlICsgc3osICIg
cmVzeW5jID0lM2x1LiVsdSUlICglbHUvJWx1KSIsCisJCXNlcV9wcmludGYoc2VxLCAiIHJlc3lu
YyA9JTNsdS4lbHUlJSAoJWx1LyVsdSkiLAogCQkJCXJlcy8xMCwgcmVzICUgMTAsIHJlc3luYywg
bWF4X2Jsb2Nrcyk7CiAJZWxzZQogCQkvKgogCQkgKiByZWNvdmVyeSAuLi4KIAkJICovCi0JCXN6
ICs9IHNwcmludGYocGFnZSArIHN6LCAiIHJlY292ZXJ5ID0lM2x1LiVsdSUlICglbHUvJWx1KSIs
CisJCXNlcV9wcmludGYoc2VxLCAiIHJlY292ZXJ5ID0lM2x1LiVsdSUlICglbHUvJWx1KSIsCiAJ
CQkJcmVzLzEwLCByZXMgJSAxMCwgcmVzeW5jLCBtYXhfYmxvY2tzKTsKIAogCS8qCkBAIC0zMTQ5
LDUwICszMTU3LDQ3IEBACiAJZGIgPSByZXN5bmMgLSAobWRkZXYtPnJlc3luY19tYXJrX2NudC8y
KTsKIAlydCA9IChkdCAqICgobWF4X2Jsb2Nrcy1yZXN5bmMpIC8gKGRiLzEwMCsxKSkpLzEwMDsK
IAotCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAiIGZpbmlzaD0lbHUuJWx1bWluIiwgcnQgLyA2
MCwgKHJ0ICUgNjApLzYpOworCXNlcV9wcmludGYoc2VxLCAiIGZpbmlzaD0lbHUuJWx1bWluIiwg
cnQgLyA2MCwgKHJ0ICUgNjApLzYpOwogCi0Jc3ogKz0gc3ByaW50ZihwYWdlICsgc3osICIgc3Bl
ZWQ9JWxkSy9zZWMiLCBkYi9kdCk7Ci0KLQlyZXR1cm4gc3o7CisJc2VxX3ByaW50ZihzZXEsICIg
c3BlZWQ9JWxkSy9zZWMiLCBkYi9kdCk7CiB9CiAKLXN0YXRpYyBpbnQgbWRfc3RhdHVzX3JlYWRf
cHJvYyhjaGFyICpwYWdlLCBjaGFyICoqc3RhcnQsIG9mZl90IG9mZiwKLQkJCWludCBjb3VudCwg
aW50ICplb2YsIHZvaWQgKmRhdGEpCitzdGF0aWMgaW50IG1kX3N0YXRlX3NlcV9zaG93KHN0cnVj
dCBzZXFfZmlsZSAqc2VxLCB2b2lkICpkdW1teSkKIHsKLQlpbnQgc3ogPSAwLCBqLCBzaXplOwor
CWludCBqLCBzaXplOwogCXN0cnVjdCBtZF9saXN0X2hlYWQgKnRtcCwgKnRtcDI7CiAJbWRrX3Jk
ZXZfdCAqcmRldjsKIAltZGRldl90ICptZGRldjsKIAotCXN6ICs9IHNwcmludGYocGFnZSArIHN6
LCAiUGVyc29uYWxpdGllcyA6ICIpOworCXNlcV9wcmludGYoc2VxLCAiUGVyc29uYWxpdGllcyA6
ICIpOwogCWZvciAoaiA9IDA7IGogPCBNQVhfUEVSU09OQUxJVFk7IGorKykKIAlpZiAocGVyc1tq
XSkKLQkJc3ogKz0gc3ByaW50ZihwYWdlK3N6LCAiWyVzXSAiLCBwZXJzW2pdLT5uYW1lKTsKKwkJ
c2VxX3ByaW50ZihzZXEsICJbJXNdICIsIHBlcnNbal0tPm5hbWUpOwogCi0Jc3ogKz0gc3ByaW50
ZihwYWdlK3N6LCAiXG4iKTsKKwlzZXFfcHJpbnRmKHNlcSwgIlxuIik7CiAKIAotCXN6ICs9IHNw
cmludGYocGFnZStzeiwgInJlYWRfYWhlYWQgIik7CisJc2VxX3ByaW50ZihzZXEsICJyZWFkX2Fo
ZWFkICIpOwogCWlmIChyZWFkX2FoZWFkW01EX01BSk9SXSA9PSBJTlRfTUFYKQotCQlzeiArPSBz
cHJpbnRmKHBhZ2Urc3osICJub3Qgc2V0XG4iKTsKKwkJc2VxX3ByaW50ZihzZXEsICJub3Qgc2V0
XG4iKTsKIAllbHNlCi0JCXN6ICs9IHNwcmludGYocGFnZStzeiwgIiVkIHNlY3RvcnNcbiIsIHJl
YWRfYWhlYWRbTURfTUFKT1JdKTsKKwkJc2VxX3ByaW50ZihzZXEsICIlZCBzZWN0b3JzXG4iLCBy
ZWFkX2FoZWFkW01EX01BSk9SXSk7CiAKIAlJVEVSQVRFX01EREVWKG1kZGV2LHRtcCkgewotCQlz
eiArPSBzcHJpbnRmKHBhZ2UgKyBzeiwgIm1kJWQgOiAlc2FjdGl2ZSIsIG1kaWR4KG1kZGV2KSwK
KwkJc2VxX3ByaW50ZihzZXEsICJtZCVkIDogJXNhY3RpdmUiLCBtZGlkeChtZGRldiksCiAJCQkJ
CQltZGRldi0+cGVycyA/ICIiIDogImluIik7CiAJCWlmIChtZGRldi0+cGVycykgewogCQkJaWYg
KG1kZGV2LT5ybykKLQkJCQlzeiArPSBzcHJpbnRmKHBhZ2UgKyBzeiwgIiAocmVhZC1vbmx5KSIp
OwotCQkJc3ogKz0gc3ByaW50ZihwYWdlICsgc3osICIgJXMiLCBtZGRldi0+cGVycy0+bmFtZSk7
CisJCQkJc2VxX3ByaW50ZihzZXEsICIgKHJlYWQtb25seSkiKTsKKwkJCXNlcV9wcmludGYoc2Vx
LCAiICVzIiwgbWRkZXYtPnBlcnMtPm5hbWUpOwogCQl9CiAKIAkJc2l6ZSA9IDA7CiAJCUlURVJB
VEVfUkRFVihtZGRldixyZGV2LHRtcDIpIHsKLQkJCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAi
ICVzWyVkXSIsCisJCQlzZXFfcHJpbnRmKHNlcSwgIiAlc1slZF0iLAogCQkJCXBhcnRpdGlvbl9u
YW1lKHJkZXYtPmRldiksIHJkZXYtPmRlc2NfbnIpOwogCQkJaWYgKHJkZXYtPmZhdWx0eSkgewot
CQkJCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAiKEYpIik7CisJCQkJc2VxX3ByaW50ZihzZXEs
ICIoRikiKTsKIAkJCQljb250aW51ZTsKIAkJCX0KIAkJCXNpemUgKz0gcmRldi0+c2l6ZTsKQEAg
LTMyMDAsMzMgKzMyMDUsNDAgQEAKIAogCQlpZiAobWRkZXYtPm5iX2RldikgewogCQkJaWYgKG1k
ZGV2LT5wZXJzKQotCQkJCXN6ICs9IHNwcmludGYocGFnZSArIHN6LCAiXG4gICAgICAlZCBibG9j
a3MiLAorCQkJCXNlcV9wcmludGYoc2VxLCAiXG4gICAgICAlZCBibG9ja3MiLAogCQkJCQkJIG1k
X3NpemVbbWRpZHgobWRkZXYpXSk7CiAJCQllbHNlCi0JCQkJc3ogKz0gc3ByaW50ZihwYWdlICsg
c3osICJcbiAgICAgICVkIGJsb2NrcyIsIHNpemUpOworCQkJCXNlcV9wcmludGYoc2VxLCAiXG4g
ICAgICAlZCBibG9ja3MiLCBzaXplKTsKIAkJfQogCiAJCWlmICghbWRkZXYtPnBlcnMpIHsKLQkJ
CXN6ICs9IHNwcmludGYocGFnZStzeiwgIlxuIik7CisJCQlzZXFfcHJpbnRmKHNlcSwgIlxuIik7
CiAJCQljb250aW51ZTsKIAkJfQogCi0JCXN6ICs9IG1kZGV2LT5wZXJzLT5zdGF0dXMgKHBhZ2Ur
c3osIG1kZGV2KTsKKwkJbWRkZXYtPnBlcnMtPnN0YXR1cyAoc2VxLCBtZGRldik7CiAKLQkJc3og
Kz0gc3ByaW50ZihwYWdlK3N6LCAiXG4gICAgICAiKTsKKwkJc2VxX3ByaW50ZihzZXEsICJcbiAg
ICAgICIpOwogCQlpZiAobWRkZXYtPmN1cnJfcmVzeW5jKSB7Ci0JCQlzeiArPSBzdGF0dXNfcmVz
eW5jIChwYWdlK3N6LCBtZGRldik7CisJCQlzdGF0dXNfcmVzeW5jIChzZXEsIG1kZGV2KTsKIAkJ
fSBlbHNlIHsKIAkJCWlmIChtZF9hdG9taWNfcmVhZCgmbWRkZXYtPnJlc3luY19zZW0uY291bnQp
ICE9IDEpCi0JCQkJc3ogKz0gc3ByaW50ZihwYWdlICsgc3osICIJcmVzeW5jPURFTEFZRUQiKTsK
KwkJCQlzZXFfcHJpbnRmKHNlcSwgIglyZXN5bmM9REVMQVlFRCIpOwogCQl9Ci0JCXN6ICs9IHNw
cmludGYocGFnZSArIHN6LCAiXG4iKTsKKwkJc2VxX3ByaW50ZihzZXEsICJcbiIpOwogCX0KLQlz
eiArPSBzdGF0dXNfdW51c2VkKHBhZ2UgKyBzeik7CisJc3RhdHVzX3VudXNlZChzZXEpOwogCi0J
cmV0dXJuIHN6OworCXJldHVybiAwOwogfQogCisKK3N0YXRpYyBpbnQgbWRfc3RhdGVfb3Blbl9m
cyhzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwlyZXR1cm4gc2lu
Z2xlX29wZW4oZmlsZSwgbWRfc3RhdGVfc2VxX3Nob3csIE5VTEwpOworfQorCisKIGludCByZWdp
c3Rlcl9tZF9wZXJzb25hbGl0eShpbnQgcG51bSwgbWRrX3BlcnNvbmFsaXR5X3QgKnApCiB7CiAJ
aWYgKHBudW0gPj0gTUFYX1BFUlNPTkFMSVRZKSB7CkBAIC0zNjMzLDE1ICszNjQ1LDEzIEBACiAK
IAlkcHJpbnRrKCJtZDogc2l6ZW9mKG1kcF9zdXBlcl90KSA9ICVkXG4iLCAoaW50KXNpemVvZiht
ZHBfc3VwZXJfdCkpOwogCi0jaWZkZWYgQ09ORklHX1BST0NfRlMKLQljcmVhdGVfcHJvY19yZWFk
X2VudHJ5KCJtZHN0YXQiLCAwLCBOVUxMLCBtZF9zdGF0dXNfcmVhZF9wcm9jLCBOVUxMKTsKLSNl
bmRpZgogfQogCiBpbnQgbWRfX2luaXQgbWRfaW5pdCh2b2lkKQogewogCXN0YXRpYyBjaGFyICog
bmFtZSA9ICJtZHJlY292ZXJ5ZCI7CiAJaW50IG1pbm9yOworCXN0cnVjdCBwcm9jX2Rpcl9lbnRy
eSAqIGVudHJ5ID0gTlVMTDsKIAogCXByaW50ayhLRVJOX0lORk8gIm1kOiBtZCBkcml2ZXIgJWQu
JWQuJWQgTUFYX01EX0RFVlM9JWQsIE1EX1NCX0RJU0tTPSVkXG4iLAogCQkJTURfTUFKT1JfVkVS
U0lPTiwgTURfTUlOT1JfVkVSU0lPTiwKQEAgLTM2NzgsNiArMzY4OCwxMyBAQAogCXJhaWRfdGFi
bGVfaGVhZGVyID0gcmVnaXN0ZXJfc3lzY3RsX3RhYmxlKHJhaWRfcm9vdF90YWJsZSwgMSk7CiAK
IAltZF9nZW5pbml0KCk7CisJZW50cnkgPSBjcmVhdGVfcHJvY19lbnRyeSgibWRzdGF0IiwgU19J
UlVHTywgTlVMTCk7CisJaWYgKCFlbnRyeSkKKwkJcHJpbnRrKEtFUk5fQUxFUlQKKwkJCSJtZDog
YnVnOiBjb3VsZG4ndCBjcmVhdGUgL3Byb2MvbWRzdGF0XG4iKTsKKwllbHNlIHsKKwkJZW50cnkt
PnByb2NfZm9wcyA9ICZtZF9zdGF0ZV9mb3BzOworCX0KIAlyZXR1cm4gKDApOwogfQogCkBAIC00
MDA1LDkgKzQwMjIsNyBAQAogCWRldmZzX3VucmVnaXN0ZXJfYmxrZGV2KE1BSk9SX05SLCJtZCIp
OwogCXVucmVnaXN0ZXJfcmVib290X25vdGlmaWVyKCZtZF9ub3RpZmllcik7CiAJdW5yZWdpc3Rl
cl9zeXNjdGxfdGFibGUocmFpZF90YWJsZV9oZWFkZXIpOwotI2lmZGVmIENPTkZJR19QUk9DX0ZT
CiAJcmVtb3ZlX3Byb2NfZW50cnkoIm1kc3RhdCIsIE5VTEwpOwotI2VuZGlmCiAKIAlkZWxfZ2Vu
ZGlzaygmbWRfZ2VuZGlzayk7CiAKLS0tIC4uL2xpbnV4LTIuNC4xOC0yNi43LngvZHJpdmVycy9t
ZC9tdWx0aXBhdGguYwlNb24gRmViIDI1IDE0OjM3OjU4IDIwMDIKKysrIC4vZHJpdmVycy9tZC9t
dWx0aXBhdGguYwlUdWUgTWFyIDExIDExOjA5OjA0IDIwMDMKQEAgLTIzLDYgKzIzLDcgQEAKICNp
bmNsdWRlIDxsaW51eC9zbGFiLmg+CiAjaW5jbHVkZSA8bGludXgvcmFpZC9tdWx0aXBhdGguaD4K
ICNpbmNsdWRlIDxhc20vYXRvbWljLmg+CisjaW5jbHVkZSA8bGludXgvc2VxX2ZpbGUuaD4KIAog
I2RlZmluZSBNQUpPUl9OUiBNRF9NQUpPUgogI2RlZmluZSBNRF9EUklWRVIKQEAgLTI4MSwxOCAr
MjgyLDE3IEBACiAJcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyBpbnQgbXVsdGlwYXRoX3N0YXR1cyAo
Y2hhciAqcGFnZSwgbWRkZXZfdCAqbWRkZXYpCitzdGF0aWMgdm9pZCBtdWx0aXBhdGhfc3RhdHVz
IChzdHJ1Y3Qgc2VxX2ZpbGUgKnNlcSwgbWRkZXZfdCAqbWRkZXYpCiB7CiAJbXVsdGlwYXRoX2Nv
bmZfdCAqY29uZiA9IG1kZGV2X3RvX2NvbmYobWRkZXYpOwotCWludCBzeiA9IDAsIGk7CisJaW50
IGk7CiAJCi0Jc3ogKz0gc3ByaW50ZiAocGFnZStzeiwgIiBbJWQvJWRdIFsiLCBjb25mLT5yYWlk
X2Rpc2tzLAorCXNlcV9wcmludGYgKHNlcSwgIiBbJWQvJWRdIFsiLCBjb25mLT5yYWlkX2Rpc2tz
LAogCQkJCQkJIGNvbmYtPndvcmtpbmdfZGlza3MpOwogCWZvciAoaSA9IDA7IGkgPCBjb25mLT5y
YWlkX2Rpc2tzOyBpKyspCi0JCXN6ICs9IHNwcmludGYgKHBhZ2Urc3osICIlcyIsCisJCXNlcV9w
cmludGYgKHNlcSwgIiVzIiwKIAkJCWNvbmYtPm11bHRpcGF0aHNbaV0ub3BlcmF0aW9uYWwgPyAi
VSIgOiAiXyIpOwotCXN6ICs9IHNwcmludGYgKHBhZ2Urc3osICJdIik7Ci0JcmV0dXJuIHN6Owor
CXNlcV9wcmludGYgKHNlcSwgIl0iKTsKIH0KIAogI2RlZmluZSBMQVNUX0RJU0sgS0VSTl9BTEVS
VCBcCi0tLSAuLi9saW51eC0yLjQuMTgtMjYuNy54L2RyaXZlcnMvbWQvcmFpZDAuYwlTdW4gU2Vw
IDMwIDE1OjI2OjA2IDIwMDEKKysrIC4vZHJpdmVycy9tZC9yYWlkMC5jCVR1ZSBNYXIgMTEgMTE6
MDk6MDQgMjAwMwpAQCAtMjAsNiArMjAsNyBAQAogCiAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+
CiAjaW5jbHVkZSA8bGludXgvcmFpZC9yYWlkMC5oPgorI2luY2x1ZGUgPGxpbnV4L3NlcV9maWxl
Lmg+CiAKICNkZWZpbmUgTUFKT1JfTlIgTURfTUFKT1IKICNkZWZpbmUgTURfRFJJVkVSCkBAIC0y
ODksNDEgKzI5MCwzOCBAQAogCXJldHVybiAwOwogfQogCQkJICAgCi1zdGF0aWMgaW50IHJhaWQw
X3N0YXR1cyAoY2hhciAqcGFnZSwgbWRkZXZfdCAqbWRkZXYpCitzdGF0aWMgdm9pZCByYWlkMF9z
dGF0dXMgKHN0cnVjdCBzZXFfZmlsZSAqc2VxLCBtZGRldl90ICptZGRldikKIHsKLQlpbnQgc3og
PSAwOwogI3VuZGVmIE1EX0RFQlVHCiAjaWZkZWYgTURfREVCVUcKIAlpbnQgaiwgazsKIAlyYWlk
MF9jb25mX3QgKmNvbmYgPSBtZGRldl90b19jb25mKG1kZGV2KTsKICAgCi0Jc3ogKz0gc3ByaW50
ZihwYWdlICsgc3osICIgICAgICAiKTsKKwlzZXFfcHJpbnRmKHNlcSwgIiAgICAgICIpOwogCWZv
ciAoaiA9IDA7IGogPCBjb25mLT5ucl96b25lczsgaisrKSB7Ci0JCXN6ICs9IHNwcmludGYocGFn
ZSArIHN6LCAiW3olZCIsCisJCXNlcV9wcmludGYoc2VxLCAiW3olZCIsCiAJCQkJY29uZi0+aGFz
aF90YWJsZVtqXS56b25lMCAtIGNvbmYtPnN0cmlwX3pvbmUpOwogCQlpZiAoY29uZi0+aGFzaF90
YWJsZVtqXS56b25lMSkKLQkJCXN6ICs9IHNwcmludGYocGFnZStzeiwgIi96JWRdICIsCisJCQlz
ZXFfcHJpbnRmKHNlcSwgIi96JWRdICIsCiAJCQkJY29uZi0+aGFzaF90YWJsZVtqXS56b25lMSAt
IGNvbmYtPnN0cmlwX3pvbmUpOwogCQllbHNlCi0JCQlzeiArPSBzcHJpbnRmKHBhZ2Urc3osICJd
ICIpOworCQkJc2VxX3ByaW50ZihzZXEsICJdICIpOwogCX0KICAgCi0Jc3ogKz0gc3ByaW50Zihw
YWdlICsgc3osICJcbiIpOworCXNlcV9wcmludGYoc2VxLCAiXG4iKTsKICAgCiAJZm9yIChqID0g
MDsgaiA8IGNvbmYtPm5yX3N0cmlwX3pvbmVzOyBqKyspIHsKLQkJc3ogKz0gc3ByaW50ZihwYWdl
ICsgc3osICIgICAgICB6JWQ9WyIsIGopOworCQlzZXFfcHJpbnRmKHNlcSwgIiAgICAgIHolZD1b
Iiwgaik7CiAJCWZvciAoayA9IDA7IGsgPCBjb25mLT5zdHJpcF96b25lW2pdLm5iX2Rldjsgaysr
KQotCQkJc3ogKz0gc3ByaW50ZiAocGFnZStzeiwgIiVzLyIsIHBhcnRpdGlvbl9uYW1lKAorCQkJ
c2VxX3ByaW50ZiAoc2VxLCAiJXMvIiwgcGFydGl0aW9uX25hbWUoCiAJCQkJY29uZi0+c3RyaXBf
em9uZVtqXS5kZXZba10tPmRldikpOwotCQlzei0tOwotCQlzeiArPSBzcHJpbnRmIChwYWdlK3N6
LCAiXSB6bz0lZCBkbz0lZCBzPSVkXG4iLAorCQlzZXFfcHJpbnRmIChzZXEsICJdIHpvPSVkIGRv
PSVkIHM9JWRcbiIsCiAJCQkJY29uZi0+c3RyaXBfem9uZVtqXS56b25lX29mZnNldCwKIAkJCQlj
b25mLT5zdHJpcF96b25lW2pdLmRldl9vZmZzZXQsCiAJCQkJY29uZi0+c3RyaXBfem9uZVtqXS5z
aXplKTsKIAl9CiAjZW5kaWYKLQlzeiArPSBzcHJpbnRmKHBhZ2UgKyBzeiwgIiAlZGsgY2h1bmtz
IiwgbWRkZXYtPnBhcmFtLmNodW5rX3NpemUvMTAyNCk7Ci0JcmV0dXJuIHN6OworCXNlcV9wcmlu
dGYoc2VxLCAiICVkayBjaHVua3MiLCBtZGRldi0+cGFyYW0uY2h1bmtfc2l6ZS8xMDI0KTsKIH0K
IAogc3RhdGljIG1ka19wZXJzb25hbGl0eV90IHJhaWQwX3BlcnNvbmFsaXR5PQotLS0gLi4vbGlu
dXgtMi40LjE4LTI2LjcueC9kcml2ZXJzL21kL3JhaWQxLmMJTW9uIEZlYiAyNCAwOToxNToyOCAy
MDAzCisrKyAuL2RyaXZlcnMvbWQvcmFpZDEuYwlUdWUgTWFyIDExIDExOjA5OjA1IDIwMDMKQEAg
LTI2LDYgKzI2LDcgQEAKICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiAjaW5jbHVkZSA8bGludXgv
cmFpZC9yYWlkMS5oPgogI2luY2x1ZGUgPGFzbS9hdG9taWMuaD4KKyNpbmNsdWRlIDxsaW51eC9z
ZXFfZmlsZS5oPgogCiAjZGVmaW5lIE1BSk9SX05SIE1EX01BSk9SCiAjZGVmaW5lIE1EX0RSSVZF
UgpAQCAtNzE0LDE4ICs3MTUsMTcgQEAKIAlyZXR1cm4gKDApOwogfQogCi1zdGF0aWMgaW50IHJh
aWQxX3N0YXR1cyAoY2hhciAqcGFnZSwgbWRkZXZfdCAqbWRkZXYpCitzdGF0aWMgdm9pZCByYWlk
MV9zdGF0dXMgKHN0cnVjdCBzZXFfZmlsZSAqc2VxLCBtZGRldl90ICptZGRldikKIHsKIAlyYWlk
MV9jb25mX3QgKmNvbmYgPSBtZGRldl90b19jb25mKG1kZGV2KTsKLQlpbnQgc3ogPSAwLCBpOwor
CWludCBpOwogCQotCXN6ICs9IHNwcmludGYgKHBhZ2Urc3osICIgWyVkLyVkXSBbIiwgY29uZi0+
cmFpZF9kaXNrcywKKwlzZXFfcHJpbnRmIChzZXEsICIgWyVkLyVkXSBbIiwgY29uZi0+cmFpZF9k
aXNrcywKIAkJCQkJCSBjb25mLT53b3JraW5nX2Rpc2tzKTsKIAlmb3IgKGkgPSAwOyBpIDwgY29u
Zi0+cmFpZF9kaXNrczsgaSsrKQotCQlzeiArPSBzcHJpbnRmIChwYWdlK3N6LCAiJXMiLAorCQlz
ZXFfcHJpbnRmIChzZXEsICIlcyIsCiAJCQljb25mLT5taXJyb3JzW2ldLm9wZXJhdGlvbmFsID8g
IlUiIDogIl8iKTsKLQlzeiArPSBzcHJpbnRmIChwYWdlK3N6LCAiXSIpOwotCXJldHVybiBzejsK
KwlzZXFfcHJpbnRmIChzZXEsICJdIik7CiB9CiAKICNkZWZpbmUgTEFTVF9ESVNLIEtFUk5fQUxF
UlQgXAotLS0gLi4vbGludXgtMi40LjE4LTI2LjcueC9kcml2ZXJzL21kL3JhaWQ1LmMJTW9uIEZl
YiAyNCAwOToxNTozNiAyMDAzCisrKyAuL2RyaXZlcnMvbWQvcmFpZDUuYwlUdWUgTWFyIDExIDEx
OjA5OjA1IDIwMDMKQEAgLTIzLDYgKzIzLDcgQEAKICNpbmNsdWRlIDxsaW51eC9yYWlkL3JhaWQ1
Lmg+CiAjaW5jbHVkZSA8YXNtL2JpdG9wcy5oPgogI2luY2x1ZGUgPGFzbS9hdG9taWMuaD4KKyNp
bmNsdWRlIDxsaW51eC9zZXFfZmlsZS5oPgogCiBzdGF0aWMgbWRrX3BlcnNvbmFsaXR5X3QgcmFp
ZDVfcGVyc29uYWxpdHk7CiAKQEAgLTE2ODEsMjMgKzE2ODIsMjIgQEAKIH0KICNlbmRpZgogCi1z
dGF0aWMgaW50IHJhaWQ1X3N0YXR1cyAoY2hhciAqcGFnZSwgbWRkZXZfdCAqbWRkZXYpCitzdGF0
aWMgdm9pZCByYWlkNV9zdGF0dXMgKHN0cnVjdCBzZXFfZmlsZSAqc2VxLCBtZGRldl90ICptZGRl
dikKIHsKIAlyYWlkNV9jb25mX3QgKmNvbmYgPSAocmFpZDVfY29uZl90ICopIG1kZGV2LT5wcml2
YXRlOwogCW1kcF9zdXBlcl90ICpzYiA9IG1kZGV2LT5zYjsKLQlpbnQgc3ogPSAwLCBpOworCWlu
dCBpOwogCi0Jc3ogKz0gc3ByaW50ZiAocGFnZStzeiwgIiBsZXZlbCAlZCwgJWRrIGNodW5rLCBh
bGdvcml0aG0gJWQiLCBzYi0+bGV2ZWwsIHNiLT5jaHVua19zaXplID4+IDEwLCBzYi0+bGF5b3V0
KTsKLQlzeiArPSBzcHJpbnRmIChwYWdlK3N6LCAiIFslZC8lZF0gWyIsIGNvbmYtPnJhaWRfZGlz
a3MsIGNvbmYtPndvcmtpbmdfZGlza3MpOworCXNlcV9wcmludGYgKHNlcSwgIiBsZXZlbCAlZCwg
JWRrIGNodW5rLCBhbGdvcml0aG0gJWQiLCBzYi0+bGV2ZWwsIHNiLT5jaHVua19zaXplID4+IDEw
LCBzYi0+bGF5b3V0KTsKKwlzZXFfcHJpbnRmIChzZXEsICIgWyVkLyVkXSBbIiwgY29uZi0+cmFp
ZF9kaXNrcywgY29uZi0+d29ya2luZ19kaXNrcyk7CiAJZm9yIChpID0gMDsgaSA8IGNvbmYtPnJh
aWRfZGlza3M7IGkrKykKLQkJc3ogKz0gc3ByaW50ZiAocGFnZStzeiwgIiVzIiwgY29uZi0+ZGlz
a3NbaV0ub3BlcmF0aW9uYWwgPyAiVSIgOiAiXyIpOwotCXN6ICs9IHNwcmludGYgKHBhZ2Urc3os
ICJdIik7CisJCXNlcV9wcmludGYgKHNlcSwgIiVzIiwgY29uZi0+ZGlza3NbaV0ub3BlcmF0aW9u
YWwgPyAiVSIgOiAiXyIpOworCXNlcV9wcmludGYgKHNlcSwgIl0iKTsKICNpZiBSQUlENV9ERUJV
RwogI2RlZmluZSBEKHgpIFwKLQlzeiArPSBzcHJpbnRmIChwYWdlK3N6LCAiPCIjeCI6JWQ+Iiwg
YXRvbWljX3JlYWQoJmNvbmYtPngpKQorCXNlcV9wcmludGYgKHNlcSwgIjwiI3giOiVkPiIsIGF0
b21pY19yZWFkKCZjb25mLT54KSkKIAlwcmludGFsbChjb25mKTsKICNlbmRpZgotCXJldHVybiBz
ejsKIH0KIAogc3RhdGljIHZvaWQgcHJpbnRfcmFpZDVfY29uZiAocmFpZDVfY29uZl90ICpjb25m
KQotLS0gLi4vbGludXgtMi40LjE4LTI2LjcueC9mcy9zZXFfZmlsZS5jCU1vbiBGZWIgMjQgMDk6
MTU6MzkgMjAwMworKysgLi9mcy9zZXFfZmlsZS5jCVR1ZSBNYXIgMTEgMTI6MjM6NDggMjAwMwpA
QCAtMjk1LDMgKzI5NSw0NyBAQAogCW0tPmNvdW50ID0gbS0+c2l6ZTsKIAlyZXR1cm4gLTE7CiB9
CisKK3N0YXRpYyB2b2lkICpzaW5nbGVfc3RhcnQoc3RydWN0IHNlcV9maWxlICpwLCBsb2ZmX3Qg
KnBvcykKK3sKKwlyZXR1cm4gTlVMTCArICgqcG9zID09IDApOworfQorCitzdGF0aWMgdm9pZCAq
c2luZ2xlX25leHQoc3RydWN0IHNlcV9maWxlICpwLCB2b2lkICp2LCBsb2ZmX3QgKnBvcykKK3sK
KwkrKypwb3M7CisJcmV0dXJuIE5VTEw7Cit9CisKK3N0YXRpYyB2b2lkIHNpbmdsZV9zdG9wKHN0
cnVjdCBzZXFfZmlsZSAqcCwgdm9pZCAqdikKK3sKK30KKworaW50IHNpbmdsZV9vcGVuKHN0cnVj
dCBmaWxlICpmaWxlLCBpbnQgKCpzaG93KShzdHJ1Y3Qgc2VxX2ZpbGUgKiwgdm9pZCopLCB2b2lk
ICpkYXRhKQoreworCXN0cnVjdCBzZXFfb3BlcmF0aW9ucyAqb3AgPSBrbWFsbG9jKHNpemVvZigq
b3ApLCBHRlBfS0VSTkVMKTsKKwlpbnQgcmVzID0gLUVOT01FTTsKKworCWlmIChvcCkgeworCQlv
cC0+c3RhcnQgPSBzaW5nbGVfc3RhcnQ7CisJCW9wLT5uZXh0ID0gc2luZ2xlX25leHQ7CisJCW9w
LT5zdG9wID0gc2luZ2xlX3N0b3A7CisJCW9wLT5zaG93ID0gc2hvdzsKKwkJcmVzID0gc2VxX29w
ZW4oZmlsZSwgb3ApOworCQlpZiAoIXJlcykKKwkJCSgoc3RydWN0IHNlcV9maWxlICopZmlsZS0+
cHJpdmF0ZV9kYXRhKS0+cHJpdmF0ZSA9IGRhdGE7CisJCWVsc2UKKwkJCWtmcmVlKG9wKTsKKwkJ
fQorCXJldHVybiByZXM7Cit9CisKK2ludCBzaW5nbGVfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwlzdHJ1Y3Qgc2VxX29wZXJhdGlvbnMgKm9wID0g
KChzdHJ1Y3Qgc2VxX2ZpbGUgKilmaWxlLT5wcml2YXRlX2RhdGEpLT5vcDsKKwlpbnQgcmVzID0g
c2VxX3JlbGVhc2UoaW5vZGUsIGZpbGUpOworCWtmcmVlKG9wKTsKKwlyZXR1cm4gcmVzOworfQor
CisKLS0tIC4uL2xpbnV4LTIuNC4xOC0yNi43LngvaW5jbHVkZS9saW51eC9zZXFfZmlsZS5oCU1v
biBGZWIgMjQgMDk6MTU6MTggMjAwMworKysgLi9pbmNsdWRlL2xpbnV4L3NlcV9maWxlLmgJVHVl
IE1hciAxMSAxMjoyNToxNSAyMDAzCkBAIC01Miw1ICs1Miw3IEBACiBpbnQgc2VxX3ByaW50Zihz
dHJ1Y3Qgc2VxX2ZpbGUgKiwgY29uc3QgY2hhciAqLCAuLi4pCiAJX19hdHRyaWJ1dGVfXyAoKGZv
cm1hdCAocHJpbnRmLDIsMykpKTsKIAoraW50IHNpbmdsZV9vcGVuKHN0cnVjdCBmaWxlICosIGlu
dCAoKikoc3RydWN0IHNlcV9maWxlICosIHZvaWQgKiksIHZvaWQgKik7CitpbnQgc2luZ2xlX3Jl
bGVhc2Uoc3RydWN0IGlub2RlICosIHN0cnVjdCBmaWxlICopOwogI2VuZGlmCiAjZW5kaWYK

------_=_NextPart_001_01C2E80B.55D5283A--
