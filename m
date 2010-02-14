From: Asdo <asdo@shiftmail.org>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 21:47:16 +0100
Message-ID: <4B786154.8090103@shiftmail.org>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <20100214193406.GA15722@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20100214193406.GA15722@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Michael Evans <mjevans1983@gmail.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Henrique de Moraes Holschuh wrote:
> On Sat, 13 Feb 2010, Michael Evans wrote:
>   
>> I remember hearing that 1.x had /no/ plans for kernel level
>> auto-detection ever.  That can be accomplished in early-userspace
>> leaving the code in the kernel much less complex, and therefore far
>> more reliable.
>>     
>
> Yes, it is far more reliable kernel side, if only because it doesn't do
> anything.
>
> But the userspace reliability is _not_ good.  initrds are a source of
> problems the moment things start to go wrong, and that's when they are not
> the problem themselves.
>
> And the end result is a system that needs manual intervention to get its
> root filesystem back.
>
> In my experience, every time we moved critical codepaths to userspace, we
> ended up decreasing the *overall* system reliability.
>   
I don't see it like this.
You have the same chance to screw up the system by making mistakes in 
the files in /etc, in the networking config, the firewall, the server 
applications...
(note: I speak for Debian/Ubuntu, redhat's initramfs I think is more messy.)
1.x autodetection worked great for me in initramfs. Basically you only 
need /etc/mdadm/mdadm.conf copied to initramfs (via update-initramfs), 
the rest is done by Debian/Ubuntu standard initramfs procedure.
Also consider 1.x allows to choose which arrays are autoassembled 
(hostname written in the array name equal to hostname in the machine or 
specified in mdadm.conf): this is more precise than 0.9 which 
autoassembles all, I think.
