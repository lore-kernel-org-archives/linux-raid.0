From: Piotr Klimek <piotr@klimek.net.pl>
Subject: Re: RAID6 reshape integer problem
Date: Wed, 8 Jan 2014 12:19:58 +0100
Message-ID: <CAM8eUy180ShDn74JDqqrK8n7tLHqd_VgAaN+3UdqqU50mA+akA@mail.gmail.com>
References: <loom.20140103T101338-556@post.gmane.org> <52C6B38E.8050804@turmel.org>
 <CAM8eUy0=YbC68vesaLPSp0RhL_2c8byVyROMGv2DdQ2_JSjYrg@mail.gmail.com> <52C6EE49.2000907@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C6EE49.2000907@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Everything works fine right now, all I have to do after reboot was
assemble array using backup file and set MDADM_GROW_ALLOW_OLD=1
enviroment variable.

Thanks for your help.

2014/1/3 Phil Turmel <philip@turmel.org>:
> On 01/03/2014 08:34 AM, Piotr Klimek wrote:
>> 2014/1/3 Phil Turmel <philip@turmel.org>
>>
>>>
>>>> After couple of days reshape stalled on 2147483648 block. I have found
>>> that
>>>> this is a bug in mdadm. 2147483648 is max integer on 32 bit system. For
>>> now
>>>> situation looks like this:
>>>
>>> You'll certainly have to take production down long enough to let a newer
>>> kernel finish the reshape.  Or you could be brave and replace the kernel
>>> and let production continue through the balance of the reshape.
>>>
>>
>> Is it safe to reboot during reshape and boot up with new kernel? I can
>> easly upgrade kernel to 3.2.0.
>>
>
> It is supposed to be safe. With a clean shutdown, the superblock will
> have a record of the reshape progress and will be able to continue after
> re-assembly.
>
> But you'll probably have to assembly manually to specify the location of
> the critical section backup file.  If your root FS is in this array,
> you'll have to intervene in the initramfs.
>
> HTH,
>
> Phil



-- 
Pozdrawiam
Piotr Klimek
