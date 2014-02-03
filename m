From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Soft RAID and EFI systems
Date: Mon, 03 Feb 2014 08:19:16 +0100
Message-ID: <80d17373-b007-4af5-bef1-09ba11a3fd77@email.android.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52EECD53.30802@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EECD53.30802@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2. Februar 2014 23:57:23 MEZ, Phil Turmel <philip@turmel.org> wrote:

>It seems to me that you should be able to create a raid1 v1.0 MD array
>of your EFI support partitions, and put the combined and signed
>kernel/initramfs onto it (mirrored to all member drives).
>
>Then set the UEFI bios to try each device's ESP in turn.
>

Smart idea ... MD RAID on the whole disk still seems more reasonable to me.

Martin


>Untested ... :-)
>
>Phil
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
