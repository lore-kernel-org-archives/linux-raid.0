From: Guoqing Jiang <jgq516@gmail.com>
Subject: Re: md-cluster Oops 4.9.13
Date: Wed, 5 Apr 2017 11:01:32 +0800
Message-ID: <58E45E0C.6030705@gmail.com>
References: <CAHkw+Lcr1+sWsQPK_ijfTHwG+zxRYT+iNhWGdpYTNxVuQi8TOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+Lcr1+sWsQPK_ijfTHwG+zxRYT+iNhWGdpYTNxVuQi8TOw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/04/2017 10:06 PM, Marc Smith wrote:
> Hi,
>
> I encountered an oops this morning when stopping a MD array
> (md-cluster)... there were 4 md-cluster array started, and they were
> in the middle of a rebuild. I stopped the first one and then stopped
> the second one immediately after and got the oops, here is a
> transcript of what was on my terminal session:
>
> [root@brimstone-1b ~]# mdadm --stop /dev/md/array1
> mdadm: stopped /dev/md/array1
> [root@brimstone-1b ~]# mdadm --stop /dev/md/array2
>
> Message from syslogd@brimstone-1b at Tue Apr  4 09:54:40 2017 ...
> brimstone-1b kernel: [649162.174685] BUG: unable to handle kernel NULL
> pointer dereference at 0000000000000098
>
> Using Linux 4.9.13 and here is the output from the kernel messages:
>
> --snip--
> [649158.014731] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: leaving the
> lockspace group...
> [649158.015233] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: group event done 0 0
> [649158.015303] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8:
> release_lockspace final free
> [649158.015331] md: unbind<nvme0n1p1>
> [649158.042540] md: export_rdev(nvme0n1p1)
> [649158.042546] md: unbind<nvme1n1p1>
> [649158.048501] md: export_rdev(nvme1n1p1)
> [649161.759022] md127: detected capacity change from 1000068874240 to 0
> [649161.759025] md: md127 stopped.
> [649162.174685] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000098
> [649162.174727] IP: [<ffffffff81868b40>] recv_daemon+0x1e9/0x373

Looks like the recv_daemon is still running after stop array, commit
48df498 "md: move bitmap_destroy to the beginning of __md_stop"
ensure it won't happen.


[snip]

> Perhaps this is already fixed in later versions? Let me know if you
> need any additional information.

Could you pls try with the latest version? Please let me know if you
still see it, thanks.

Regards,
Guoqing

