From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk
 can see them
Date: Thu, 18 Dec 2008 23:22:30 +0100
Message-ID: <494ACD26.2040809@gmail.com>
References: <49402CFE.3080708@gmail.com> <18759.8246.568849.244513@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18759.8246.568849.244513@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> On Wednesday December 10, torarnv@gmail.com wrote:
>>> Running 'partprobe -s' successfully finds the two missing partitions
>>> and adds device nodes, and the nodes can be 'file -sL'ed, but when
>>> trying to assemble the array again with these new nodes in the system,
>>> I'm told that sdc1 is not found, and after the --assemble is done, the
>>> device nodes are once again missing (!) see [4]

Neil Brown wrote:
> Can you:
>   strace -o /tmp/str -s 200 mdadm --assemble --scan --verbose /dev/md0

Should I try this after doing partprobe first? In that case /dev/sdb1
and /dev/sdc1 exist, and we might see from the trace what causes them to
disappear?

>> [4] http://pastebin.com/m4475c9ae   partprobe + mdadm --assemble

Tor Arne

