From: Anthonys Lists <antlists@youngman.org.uk>
Subject: Re: raid 5 crashed
Date: Mon, 30 May 2016 20:04:25 +0100
Message-ID: <574C8EB9.3070706@youngman.org.uk>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 30/05/2016 16:01, bobzer wrote:
> HI,
>
> i did a dd_rescue which recovered a lot but not everything :
> # Rescue Logfile. Created by GNU ddrescue version 1.19
> # Command line: ddrescue -d -f -r3 /dev/sdf1
> wdc/9bececcb-d520-ca38-fd88-d9565718e361.dd
> wdc/9bececcb-d520-ca38-fd88-d9565718e361.mapfile
> # Start time:   2016-05-29 22:32:38
> # Current time: 2016-05-29 23:04:49
> # Finished
> # current_pos  current_status
> 0x129F7DB6000     +
> #      pos        size  status
> 0x00000000  0x1118E2AB200  +
> 0x1118E2AB200  0x00001000  -
> 0x1118E2AC200  0x00090000  +
> 0x1118E33C200  0x00001000  -
> 0x1118E33D200  0x00817000  +
> 0x1118EB54200  0x00001000  -
> 0x1118EB55200  0x0016B000  +
> 0x1118ECC0200  0x00001000  -
> 0x1118ECC1200  0x641976000  +
> 0x117D0637200  0x00001000  -
> 0x117D0638200  0x000FE000  +
> 0x117D0736200  0x00001000  -
> 0x117D0737200  0x000EC000  +
> 0x117D0823200  0x00001000  -
> 0x117D0824200  0x0010C000  +
> 0x117D0930200  0x00001000  -
> 0x117D0931200  0x0010C000  +
> 0x117D0A3D200  0x00001000  -
> 0x117D0A3E200  0x00375000  +
> 0x117D0DB3200  0x00001000  -
> 0x117D0DB4200  0x0010B000  +
> 0x117D0EBF200  0x00002000  -
> 0x117D0EC1200  0x0010C000  +
> 0x117D0FCD200  0x00001000  -
> 0x117D0FCE200  0x001EB000  +
> 0x117D11B9200  0x00001000  -
> 0x117D11BA200  0x00112000  +
> 0x117D12CC200  0x00001000  -
> 0x117D12CD200  0x00077000  +
> 0x117D1344200  0x00001000  -
> 0x117D1345200  0x000EB000  +
> 0x117D1430200  0x00001000  -
> 0x117D1431200  0x000FD000  +
> 0x117D152E200  0x00001000  -
> 0x117D152F200  0x0010C000  +
> 0x117D163B200  0x00001000  -
> 0x117D163C200  0x00251000  +
> 0x117D188D200  0x00002000  -
> 0x117D188F200  0x12264B3000  +
> 0x129F7D42200  0x00001000  -
> 0x129F7D43200  0x0004F000  +
> 0x129F7D92200  0x00001000  -
> 0x129F7D93200  0x00022000  +
> 0x129F7DB5200  0x00001000  -
> 0x129F7DB6200  0xA7C90DA200  +
>
> i don't know if i can recover more but i tried to reassemble the raid
> and it work but during the rebuilding the sdb1 failed again
> so my data are there but i'm not sure to know what to do to get them all.
>
> thanks
>
>
Did you follow Mikael's advice? Can you do smartctl on the drive (I 
think the option you want is "smartctl -x" - display "extended all") and 
post the output?

We're assuming you're using proper raid-capable drives, but if you 
aren't then the drives could be fine but giving up under load and 
causing your raid problems. On the other hand, if your drives are proper 
raid drives, then they're probably not fit for anything more than the 
scrapheap.

Cheers,
Wol
