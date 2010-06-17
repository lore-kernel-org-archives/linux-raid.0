From: aragonx@dcsnow.com
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 15:56:26 -0400
Message-ID: <cdd34437de763739fce9bce4297300da.squirrel@www.dcsnow.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
    <20100617100109.32a20ffa@natsu>
    <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
    <20100617221300.3e30afe0@natsu>
    <db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> time dd if=/dev/zero of=zerofile bs=1M count=2048 conv=fdatasync,notrunc
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 28.728 s, 74.8 MB/s
>
> real    0m28.732s
> user    0m0.004s
> sys     0m23.600s
>
> time dd if=/dev/zero of=zerofile bs=1M count=6144 conv=fdatasync,notrunc
> 6144+0 records in
> 6144+0 records out
> 6442450944 bytes (6.4 GB) copied, 196.618 s, 32.8 MB/s
>
> real    3m16.622s
> user    0m0.012s
> sys     0m27.726s

Bleh, sorry for so many posts.  I ran the same DD test on my OS disk that
is on the same controller as 4 of the RAID disks above.  It did much
better although that drive is slower than the ones that belong to the
RAID.

time dd if=/dev/zero of=zerofile bs=1M count=6144 conv=fdatasync,notrunc
6144+0 records in
6144+0 records out
6442450944 bytes (6.4 GB) copied, 109.823 s, 58.7 MB/s

real    1m49.827s
user    0m0.014s
sys     0m20.965s



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

