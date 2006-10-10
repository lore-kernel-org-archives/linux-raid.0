From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 10 Oct 2006 12:27:51 +0200
Message-ID: <452B75A7.4060705@tuxes.nl>
References: <17532.59212.364233.765155@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>	<17532.62343.933852.982391@cse.unsw.edu.au>	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>	<17534.22056.981033.686846@cse.unsw.edu.au>	<Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>	<17535.59496.431182.785563@cse.unsw.edu.au>	<448F0994.6050704@tmr.com>	<17551.18061.160356.35034@cse.unsw.!edu.au>	<4528377A.2010001@cjx.com>	<20061009110344.GA7104@cjx.com>	<17706.54775.830279.53938@cse.unsw.edu.au>	<452AD986.1010304@cjx.com> <17706.58512.374925.103556@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17706.58512.374925.103556@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Neil Brown wrote:
> On Tuesday October 10, chris@cjx.com wrote:
>   
>> Very happy to. Let me know what you'd like me to do.
>>     
>
> Cool thanks.
> (snip)
>   
I don't know if it's useful information, but I'm encountering the same
problem here, in a totally different situation. I'm using Peter Breuers
ENBD (you probably know him, since he started a discussion about request
retries with exponential timeouts and a communication channel to raid a
while ago) to import a total of 12 devices from other machines to
compose those disks into 3 arrays of RAID5. Those 3 arrays are combined
in one VG with one LV, running CryptoLoop on top. Last, but not least, a
ReiserFS is created on the loopback device. I'm using the Debian Etch
stock 2.6.17-kernel, by the way.

When doing a lot of I/O on the ReiserFS (like a "reiserfsck
--rebuild-tree"), the machine suddenly gets stuck, I think after filling
it's memory with buffers. I've been doing a lot of debugging with Peter,
attached you'll find a "ps -axl" with a widened WCHAN column to see that
some of the enbd-client processes get stuck in the RAID code. We've not
been able find out how ENBD gets into the RAID code, but I don't think
that's really relevant right now. Here's the relevant part of ps:

ps ax -o f,uid,pid,ppid,pri,ni,vsz,rss,wchan:30,stat,tty,time,command
(only the relevant rows)

> F   UID   PID  PPID PRI  NI   VSZ  RSS WCHAN                          STAT TT           TIME COMMAND
> (snip)
> 5     0 26523     1  23   0  2140 1052 -                              Ss   ?        00:00:00 enbd-client iss01 1300 -i iss01-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndi
> 5     0 26540     1  23   0  2140 1048 get_active_stripe              Ds   ?        00:00:00 enbd-client iss04 1300 -i iss04-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndl
> 5     0 26552     1  23   0  2140 1044 -                              Ss   ?        00:00:00 enbd-client iss02 1200 -i iss02-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndf
> 5     0 26556     1  23   0  2140 1048 -                              Ss   ?        00:00:00 enbd-client iss01 1100 -i iss01-hda5 -n 2 -e -m -b 4096 -p 30 /dev/nda
> 5     0 26561     1  23   0  2140 1052 get_active_stripe              Ds   ?        00:00:00 enbd-client iss02 1100 -i iss02-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndb
> 5     0 26564     1  23   0  2144 1052 -                              Ss   ?        00:00:00 enbd-client iss03 1200 -i iss03-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndg
> 5     0 26568     1  23   0  2144 1052 -                              Ss   ?        00:00:00 enbd-client iss04 1200 -i iss04-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndh
> 5     0 26581     1  23   0  2144 1052 -                              Ss   ?        00:00:00 enbd-client iss03 1100 -i iss03-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndc
> 5     0 26590     1  23   0  2140 1048 -                              Ss   ?        00:00:00 enbd-client iss01 1200 -i iss01-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/nde
> 5     0 26606     1  23   0  2144 1052 -                              Ss   ?        00:00:00 enbd-client iss02 1300 -i iss02-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndj
> 5     0 26614     1  23   0  2144 1052 -                              Ss   ?        00:00:00 enbd-client iss03 1300 -i iss03-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndk
> 5     0 26616     1  23   0  2144 1056 -                              Ss   ?        00:00:00 enbd-client iss04 1100 -i iss04-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndd
> 5     0 26617 26523  24   0  2140  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss01 1300 -i iss01-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndi
> 5     0 26618 26523  24   0  2140  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss01 1300 -i iss01-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndi
> 5     0 26619 26540  24   0  2140  948 enbd_get_req                   S    ?        00:00:01 enbd-client iss04 1300 -i iss04-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndl
> 5     0 26620 26540  24   0  2140  948 enbd_get_req                   S    ?        00:00:01 enbd-client iss04 1300 -i iss04-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndl
> 5     0 26621 26552  24   0  2140  948 get_active_stripe              D    ?        00:32:11 enbd-client iss02 1200 -i iss02-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndf
> 5     0 26622 26552  24   0  2140  948 get_active_stripe              D    ?        00:32:18 enbd-client iss02 1200 -i iss02-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndf
> 5     0 26623 26564  23   0  2144  956 enbd_get_req                   S    ?        00:32:27 enbd-client iss03 1200 -i iss03-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndg
> 5     0 26624 26564  24   0  2144  956 enbd_get_req                   S    ?        00:32:37 enbd-client iss03 1200 -i iss03-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndg
> 5     0 26625 26568  24   0  2144  956 enbd_get_req                   S    ?        00:35:35 enbd-client iss04 1200 -i iss04-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndh
> 5     0 26626 26561  24   0  2140  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss02 1100 -i iss02-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndb
> 5     0 26627 26561  24   0  2140  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss02 1100 -i iss02-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndb
> 5     0 26628 26568  24   0  2144  956 enbd_get_req                   S    ?        00:35:37 enbd-client iss04 1200 -i iss04-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/ndh
> 5     0 26629 26556  24   0  2140  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss01 1100 -i iss01-hda5 -n 2 -e -m -b 4096 -p 30 /dev/nda
> 5     0 26630 26556  24   0  2140  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss01 1100 -i iss01-hda5 -n 2 -e -m -b 4096 -p 30 /dev/nda
> 5     0 26631 26581  24   0  2144  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss03 1100 -i iss03-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndc
> 5     0 26632 26581  24   0  2144  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss03 1100 -i iss03-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndc
> 5     0 26633 26590  24   0  2140  952 enbd_get_req                   S    ?        00:36:58 enbd-client iss01 1200 -i iss01-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/nde
> 5     0 26634 26590  24   0  2140  952 enbd_get_req                   S    ?        00:36:50 enbd-client iss01 1200 -i iss01-hdc5 -n 2 -e -m -b 4096 -p 30 /dev/nde
> 5     0 26635 26606  24   0  2144  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss02 1300 -i iss02-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndj
> 5     0 26636 26606  24   0  2144  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss02 1300 -i iss02-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndj
> 5     0 26637 26616  24   0  2144  952 enbd_get_req                   S    ?        00:00:00 enbd-client iss04 1100 -i iss04-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndd
> 5     0 26638 26616  23   0  2144  952 enbd_get_req                   S    ?        00:00:00 enbd-client iss04 1100 -i iss04-hda5 -n 2 -e -m -b 4096 -p 30 /dev/ndd
> 5     0 26639 26614  23   0  2144  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss03 1300 -i iss03-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndk
> 5     0 26640 26614  24   0  2144  948 enbd_get_req                   S    ?        00:00:00 enbd-client iss03 1300 -i iss03-hdd -n 2 -e -m -b 4096 -p 30 /dev/ndk
>   

I've tried this "reiserfsck --rebuild-tree" a couple of times, it keeps
hanging at the same point when my memory gets filled with buffers. My
assumption is, that reiserfs is writing out too fast, the network (ENBD)
can't handle it and after a while there's no memory left for TCP
buffers. I've solved this problem by editing
/proc/sys/vm/min_free_kbytes to force the kernel to leave some memory
for the TCP buffers and other interrupt handling.

I'm not able to install a vanilla kernel with some patches, but I would
be happy to provide some extra details about the crash if you want me
to. I assume I can even reproduce it, on another cluster however, since
I've recreated a (ext3) filesystem on the cluster we're talking about.

Regards

  -- Bas van Schaik


