From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: Re: [PATCH v2] mdadm/Detail: show correct state for cluster-md array
Date: Sun, 26 Jul 2020 17:22:41 +0800
Message-ID: <7aeb1f5a-df3c-183e-93cd-61631a40e9b5@suse.com>
References: <1595401905-3459-1-git-send-email-heming.zhao@suse.com>
 <7697b7eb-76f9-8102-a490-1684e5f18acf@suse.com>
 <5F1D3B50.8080006@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5F1D3B50.8080006@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
Cc: neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

Hello Wols,

I just started to learn mdadm code. Maybe there are some historical reasons to keep leaked issue. 
I guess your said daemon mode is: "mdadm --monitor --daemonise ...".
After very quickly browsing the code in Monitor.c, these mode check /proc/mdstat, send ioctl GET_ARRAY_INFO, and
read some /sys/block/mdX/md/xx files. There is no way to call ExamineBitmap().
In currently mdadm code, the only way to call ExamineBitmap() is by cmd "mdadm -X /dev/sdX". So as my last mail said, when the mdadm program finish, all leaked memory will be released.
And last week, before I send v2 patch, I try to use valgrind to check memory related issue, there are many places to leak. e.g. 
```
<1>
# valgrind --leak-check=full  ./mdadm -D /dev/md0
... ...
==3929== 
==3929== HEAP SUMMARY:
==3929==     in use at exit: 12,991 bytes in 190 blocks
==3929==   total heap usage: 354 allocs, 164 frees, 2,414,075 bytes allocated
==3929== 
==3929== 184 bytes in 1 blocks are definitely lost in loss record 15 of 24
==3929==    at 0x4C306B5: calloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==3929==    by 0x47EB4C: xcalloc (xmalloc.c:62)
==3929==    by 0x4495E2: match_metadata_desc1 (super1.c:2316)
==3929==    by 0x4125CE: super_by_fd (util.c:1213)
==3929==    by 0x424E53: Detail (Detail.c:103)
==3929==    by 0x408AAA: misc_list (mdadm.c:1970)
==3929==    by 0x407CEF: main (mdadm.c:1640)
==3929== 
==3929== LEAK SUMMARY:
==3929==    definitely lost: 184 bytes in 1 blocks
==3929==    indirectly lost: 0 bytes in 0 blocks
==3929==      possibly lost: 0 bytes in 0 blocks
==3929==    still reachable: 12,807 bytes in 189 blocks
==3929==         suppressed: 0 bytes in 0 blocks
==3929== Reachable blocks (those to which a pointer was found) are not shown.
==3929== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==3929== 
==3929== For lists of detected and suppressed errors, rerun with: -s
==3929== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 0 from 0)


<2>
valgrind --leak-check=full  ./mdadm -X /dev/sda
 ... ...
==4077== 
==4077== HEAP SUMMARY:
==4077==     in use at exit: 8,944 bytes in 58 blocks
==4077==   total heap usage: 161 allocs, 103 frees, 458,399 bytes allocated
==4077== 
==4077== 184 bytes in 1 blocks are definitely lost in loss record 13 of 19
==4077==    at 0x4C306B5: calloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==4077==    by 0x47EB4C: xcalloc (xmalloc.c:62)
==4077==    by 0x412885: guess_super_type (util.c:1290)
==4077==    by 0x47359F: guess_super (mdadm.h:1222)
==4077==    by 0x473C1C: bitmap_file_open (bitmap.c:205)
==4077==    by 0x473DB1: ExamineBitmap (bitmap.c:253)
==4077==    by 0x408B62: misc_list (mdadm.c:1988)
==4077==    by 0x407CEF: main (mdadm.c:1640)
==4077== 
==4077== 736 bytes in 4 blocks are definitely lost in loss record 15 of 19
==4077==    at 0x4C306B5: calloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==4077==    by 0x47EB4C: xcalloc (xmalloc.c:62)
==4077==    by 0x412885: guess_super_type (util.c:1290)
==4077==    by 0x47359F: guess_super (mdadm.h:1222)
==4077==    by 0x473C1C: bitmap_file_open (bitmap.c:205)
==4077==    by 0x4742A5: ExamineBitmap (bitmap.c:337)
==4077==    by 0x408B62: misc_list (mdadm.c:1988)
==4077==    by 0x407CEF: main (mdadm.c:1640)
==4077== 
==4077== LEAK SUMMARY:
==4077==    definitely lost: 920 bytes in 5 blocks
==4077==    indirectly lost: 0 bytes in 0 blocks
==4077==      possibly lost: 0 bytes in 0 blocks
==4077==    still reachable: 8,024 bytes in 53 blocks
==4077==         suppressed: 0 bytes in 0 blocks
==4077== Reachable blocks (those to which a pointer was found) are not shown.
==4077== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==4077== 
==4077== For lists of detected and suppressed errors, rerun with: -s
==4077== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)


<3>
# valgrind --leak-check=full  ./mdadm -a /dev/md0 /dev/sdc
  ... ...
==4096== Warning: noted but unhandled ioctl 0x1269 with no size/direction hints.
==4096==    This could cause spurious value errors to appear.
==4096==    See README_MISSING_SYSCALL_OR_IOCTL for guidance on writing a proper wrapper.
mdadm: added /dev/sdc
==4096== Syscall param write(buf) points to uninitialised byte(s)
==4096==    at 0x512C244: write (in /lib64/libc-2.26.so)
==4096==    by 0x57FB706: ??? (in /usr/lib64/libdlm_lt.so.3.0)
==4096==    by 0x57FC0F1: dlm_ls_unlock (in /usr/lib64/libdlm_lt.so.3.0)
==4096==    by 0x40F84E: cluster_release_dlmlock (util.c:198)
==4096==    by 0x40837B: main (mdadm.c:1780)
==4096==  Address 0x1ffefffc0e is on thread 1's stack
==4096==  in frame #2, created by dlm_ls_unlock (???:)
==4096== 
==4096== Syscall param write(buf) points to uninitialised byte(s)
==4096==    at 0x512C244: write (in /lib64/libc-2.26.so)
==4096==    by 0x57FC4E0: dlm_release_lockspace (in /usr/lib64/libdlm_lt.so.3.0)
==4096==    by 0x40F906: cluster_release_dlmlock (util.c:218)
==4096==    by 0x40837B: main (mdadm.c:1780)
==4096==  Address 0x1ffeffeb5e is on thread 1's stack
==4096==  in frame #1, created by dlm_release_lockspace (???:)
==4096== 
==4096== 
==4096== HEAP SUMMARY:
==4096==     in use at exit: 13,737 bytes in 197 blocks
==4096==   total heap usage: 278 allocs, 81 frees, 3,253,146 bytes allocated
==4096== 
==4096== 184 bytes in 1 blocks are definitely lost in loss record 19 of 30
==4096==    at 0x4C306B5: calloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==4096==    by 0x47EB4C: xcalloc (xmalloc.c:62)
==4096==    by 0x4495E2: match_metadata_desc1 (super1.c:2316)
==4096==    by 0x4125CE: super_by_fd (util.c:1213)
==4096==    by 0x419258: Manage_subdevs (Manage.c:1344)
==4096==    by 0x407398: main (mdadm.c:1477)
==4096== 
==4096== 184 bytes in 1 blocks are definitely lost in loss record 20 of 30
==4096==    at 0x4C306B5: calloc (in /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==4096==    by 0x47EB4C: xcalloc (xmalloc.c:62)
==4096==    by 0x4127E7: dup_super (util.c:1268)
==4096==    by 0x417D73: Manage_add (Manage.c:813)
==4096==    by 0x419C3F: Manage_subdevs (Manage.c:1564)
==4096==    by 0x407398: main (mdadm.c:1477)
==4096== 
==4096== LEAK SUMMARY:
==4096==    definitely lost: 368 bytes in 2 blocks
==4096==    indirectly lost: 0 bytes in 0 blocks
==4096==      possibly lost: 0 bytes in 0 blocks
==4096==    still reachable: 13,369 bytes in 195 blocks
==4096==         suppressed: 0 bytes in 0 blocks
==4096== Reachable blocks (those to which a pointer was found) are not shown.
==4096== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==4096== 
==4096== Use --track-origins=yes to see where uninitialised values come from
==4096== For lists of detected and suppressed errors, rerun with: -s
==4096== ERROR SUMMARY: 5 errors from 5 contexts (suppressed: 0 from 0)
```

Thanks,
heming

On 7/26/20 4:14 PM, Wols Lists wrote:
> On 22/07/20 08:20, heming.zhao@suse.com wrote:
>> During I was creating patch, I found the ExamineBitmap() has memory leak issue.
>> I am not sure whether the leak issue should be fixed.
>> (Because when mdadm cmd finish, all leaked memory will be released).
>> The IsBitmapDirty() used some of ExamineBitmap() code, and I only fixed leaked issue in IsBitmapDirty().
>>
> My gut feel?
> 
> Firstly, "do things right" - it should be fixed.
> Second - are you sure this code is not run while mdadm is running as a
> daemon? It's all very well saying it will be released, but but mdadm
> could be running for a looonnngg time.
> 
> Cheers,
> Wol
> 
