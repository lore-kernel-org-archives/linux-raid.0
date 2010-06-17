From: aragonx@dcsnow.com
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 15:51:46 -0400
Message-ID: <38599704579ec5d844bada876838dda7.squirrel@www.dcsnow.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
    <20100617100109.32a20ffa@natsu>
    <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
    <20100617221300.3e30afe0@natsu> <4C1A50FA.50504@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1A50FA.50504@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Actually, you have not said a word about which controllers you use (for
> the drives).  Using the wrong controller can drain speed a lot.  As from
> the kernel benchmarks it seems like neither RAM nor computing power are
> the bottlenecks.
>
> Some SATA-controllers handle "nearly parallel" writes to multiple drives
> better than others.  SiI products for example have a noticeable drop-off
> for each disk you add.  Pretty late Intels nearly show no impact of many
> disks in parallel.  So maybe that could be the topic you should be
> after.  (And maybe a lspci could help :)
>
> Stefan

Hi Stefan,

Here is the output of lspci.  There are 5 disks on the ATI controller. 
Four of them are part of the RAID.  The last disk is on the JMicron
controller which is a PCIE-1x card.  I can move one more disk to the
JMicron controller if you think that would help.  Or just purchase a new 4
port controller?

lspci|grep SATA
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller
[IDE mode]
02:00.0 SATA controller: JMicron Technologies, Inc. 20360/20363 Serial ATA
Controller (rev 03)

---
Will Y.


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

