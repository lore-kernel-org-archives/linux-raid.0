From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid 5 crashed
Date: Tue, 31 May 2016 19:49:33 +0100
Message-ID: <574DDCBD.40801@youngman.org.uk>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <574D958F.8060209@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 31/05/16 14:45, Phil Turmel wrote:
> On 05/30/2016 06:00 PM, bobzer wrote:
>> I did follow his advice for the smartctl i can't right now but i will
>> post the output
>> my drives are desktop grade normal seagate, not NAS nor entreprise so
>> i will retry but i will limit the speed of reconstruction with :
>> echo 40000 > /proc/sys/dev/raid/speed_limit_max
>> echo 1000 > /proc/sys/dev/raid/speed_limit_min
>> I hope that it will permit to finish the rebuilding
> 
> No, that is unlikely to help.  You need to read about "timeout mismatch"
> as you clearly have a bad case of it.  This is not a new issue, as you
> can see from the dates of the following:
> 
> http://marc.info/?l=linux-raid&m=139050322510249&w=2
> http://marc.info/?l=linux-raid&m=135863964624202&w=2
> http://marc.info/?l=linux-raid&m=135811522817345&w=1
> http://marc.info/?l=linux-raid&m=133761065622164&w=2
> http://marc.info/?l=linux-raid&m=132477199207506
> http://marc.info/?l=linux-raid&m=133665797115876&w=2
> http://marc.info/?l=linux-raid&m=142487508806844&w=3
> http://marc.info/?l=linux-raid&m=144535576302583&w=2
> 
And you need to follow Mikael's advice EVERY boot. It sounds like this
is your problem. So once you've managed to get your array reconstructed,
you need to replace your drives FAST.

In fact, with your setup, I'd be inclined to GIVE UP RIGHT NOW trying to
reconstruct the raid as-is. Get four replacement, NAS drives (they can
be 3TB drives if you want to increase the space, this technique should
work regardless...).

When the new drives arrive, copy each old drive in turn onto a new drive...

dd if=/dev/sda of=/dev/sde

etc etc. Expect it to take a little while ... (others may chime in and
tell you to use ddrescue rather than dd - I don't know which one is
best, both should work).

Once you've copied and replaced all four drives, your system should boot
and recover without difficulty. And if there IS a problem, at least you
still have the original drives UNTOUCHED.

Once you've got your system back, you should be able to claim the new
space if you did buy bigger drives. The old drives are probably fine -
you've just gone over the size limit at which fatal errors become a
probability for non-NAS drives.

I've got two 3TB Seagate Barracudas in a mirror. I can get away with a
mirror, I hope, but there's no way I'd go to raid 5 without proper NAS
drives (I'm a bit gutted - I originally bought the Barracudas intending
to do just that, but 3x3TB is just asking for trouble!)

Cheers,
Wol
