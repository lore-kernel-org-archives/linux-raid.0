From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: md-cluster Oops 4.9.13
Date: Mon, 10 Apr 2017 09:25:00 -0400
Message-ID: <CAHkw+Ld=yv=LoBKFUxNO6dEocOKzq-pFR=Tfk50OULXJ8NN9eQ@mail.gmail.com>
References: <CAHkw+Lcr1+sWsQPK_ijfTHwG+zxRYT+iNhWGdpYTNxVuQi8TOw@mail.gmail.com>
 <58E45E0C.6030705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58E45E0C.6030705@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Sorry for the delay... I was hoping to cherry-pick this and test
against 4.9.x, but it didn't apply cleanly, although it looks trivial
to do it by hand. Is it recommended/okay to test this patch against
4.9.x? Will the fix eventually be merged into 4.9.x?


--Marc

On Tue, Apr 4, 2017 at 11:01 PM, Guoqing Jiang <jgq516@gmail.com> wrote:
>
>
> On 04/04/2017 10:06 PM, Marc Smith wrote:
>>
>> Hi,
>>
>> I encountered an oops this morning when stopping a MD array
>> (md-cluster)... there were 4 md-cluster array started, and they were
>> in the middle of a rebuild. I stopped the first one and then stopped
>> the second one immediately after and got the oops, here is a
>> transcript of what was on my terminal session:
>>
>> [root@brimstone-1b ~]# mdadm --stop /dev/md/array1
>> mdadm: stopped /dev/md/array1
>> [root@brimstone-1b ~]# mdadm --stop /dev/md/array2
>>
>> Message from syslogd@brimstone-1b at Tue Apr  4 09:54:40 2017 ...
>> brimstone-1b kernel: [649162.174685] BUG: unable to handle kernel NULL
>> pointer dereference at 0000000000000098
>>
>> Using Linux 4.9.13 and here is the output from the kernel messages:
>>
>> --snip--
>> [649158.014731] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: leaving the
>> lockspace group...
>> [649158.015233] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: group event
>> done 0 0
>> [649158.015303] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8:
>> release_lockspace final free
>> [649158.015331] md: unbind<nvme0n1p1>
>> [649158.042540] md: export_rdev(nvme0n1p1)
>> [649158.042546] md: unbind<nvme1n1p1>
>> [649158.048501] md: export_rdev(nvme1n1p1)
>> [649161.759022] md127: detected capacity change from 1000068874240 to 0
>> [649161.759025] md: md127 stopped.
>> [649162.174685] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000098
>> [649162.174727] IP: [<ffffffff81868b40>] recv_daemon+0x1e9/0x373
>
>
> Looks like the recv_daemon is still running after stop array, commit
> 48df498 "md: move bitmap_destroy to the beginning of __md_stop"
> ensure it won't happen.
>
>
> [snip]
>
>> Perhaps this is already fixed in later versions? Let me know if you
>> need any additional information.
>
>
> Could you pls try with the latest version? Please let me know if you
> still see it, thanks.
>
> Regards,
> Guoqing
>
