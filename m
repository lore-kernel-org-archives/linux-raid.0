From: David Greaves <david@dgreaves.com>
Subject: Re: sata controllers status=0x51 { DriveReady SeekComplete Error
 } error=0x84 { DriveStatusError BadCRC }
Date: Fri, 31 Mar 2006 09:57:48 +0100
Message-ID: <442CEF0C.4000707@dgreaves.com>
References: <200603301051.31551.mlaks@verizon.net> <442C14A8.4030606@dgreaves.com> <loom.20060331T005324-626@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20060331T005324-626@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: mitchell laks <mlaks2000@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mitchell laks wrote:

>David Greaves <david <at> dgreaves.com> writes:
>  
>
>>2.6.16 seems to be much better (fewer 'odd' errors reported and md
>>doesn't mind)
>>    
>>
>
>"Fewer" - oh oh. Can you quantify this for me? I seem to be getting around 
>8-9 /10 days = or averaging about 1 per rsync. 
>  
>
Not sure what triggers them - they're at the end of the message.

>I am now very worried.
>  
>
I didn't notice any data loss. I suspect I was lucky.

>I need to do some testing off line with the new kernel  before 
>putting out the fix. 
>
>Is your experience also with an Asus board with a via vt8237 powered
> sata  connector?
>  
>
Asus A7V600-X mainboard

0000:00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600
AGP] Host Bridge (rev 80)
0000:00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
0000:00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA
RAID Controller (rev 80)
I also have a plug-in
0000:00:0a.0 Mass storage controller: Silicon Image, Inc. SiI 3112
[SATALink/SATARaid] Serial ATA Controller (rev 02)

>Would you suggest I try the promise sata connector instead, before 
>I try to move
>over to the newer kernel? Or both? 
>  
>
Yes. There is a *definite* chance that there is a hardware fault and you
need to try hard to confirm that it's not.
I ended up spending over $100 on a new (unneeded) PSU - just in case...

>Could you give me more of your experience?
>  
>
Honestly it's pretty well documented on linux-ide.

The only think I haven't always mentioned is when the array went down.
I always got it back through an assemble/force - although once I had 2
of 3 kicked so quickly that they had the same (lower) event count and I
used the 'faulty' devices to reconstruct the array.

David


grep ata messages.log:
Mar 26 15:46:47 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 26 15:46:47 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 26 15:47:33 haze kernel: ata2: status=0x59 { DriveReady SeekComplete
DataRequest Error }
Mar 26 15:47:33 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 26 15:47:33 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 26 16:20:22 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 26 16:20:22 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 26 19:50:12 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 26 19:50:12 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:04 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:04 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:06 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:06 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:08 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:08 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:17 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:17 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:29 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:29 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:33 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:33 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:38 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:38 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:45 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:45 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:52 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:52 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:56 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:56 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:25:59 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:25:59 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:26:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:26:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:26:14 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:26:14 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:26:20 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:26:20 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:27:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:27:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:27:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:27:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:27:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:27:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 06:27:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 06:27:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 08:38:47 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 08:38:47 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 08:38:47 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 08:38:47 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 08:38:48 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 08:38:48 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 08:38:48 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 08:38:48 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 08:38:49 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 08:38:49 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 08:38:51 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 08:38:51 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 08:38:51 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 08:38:51 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 09:13:45 haze kernel: ata1: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 09:13:45 haze kernel: ata1: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 09:29:36 haze kernel: ata1: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 09:29:36 haze kernel: ata1: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 10:06:06 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 10:06:06 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 10:19:04 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 10:19:04 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 12:00:53 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 12:00:53 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 12:50:08 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 12:50:08 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 17:22:47 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 17:22:47 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 27 17:57:13 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 27 17:57:13 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:26:06 haze kernel: ata2: status=0xd8 { Busy }
Mar 28 06:27:06 haze kernel: ata2: status=0xd8 { Busy }
Mar 28 06:27:06 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:06 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:14 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:14 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:16 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:16 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:19 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:19 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:21 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:21 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:22 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:22 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:28 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:28 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:36 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:36 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:36 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:36 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:36 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:36 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:52 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:52 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:27:54 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:27:54 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:28:26 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:28:26 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:28:39 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:28:39 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 06:29:05 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 06:29:05 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 09:01:55 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 09:01:55 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 09:39:02 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 09:39:02 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 11:31:54 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 11:31:54 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 12:07:52 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 12:07:52 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 12:12:41 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 12:12:41 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 12:39:34 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 12:39:34 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 12:49:41 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 12:49:41 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 13:45:54 haze kernel: MCE: The hardware reports a non fatal,
correctable incident occurred on CPU 0.
Mar 28 13:52:15 haze kernel: ata1: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 13:52:15 haze kernel: ata1: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 13:55:41 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 13:55:41 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 18:34:35 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 18:34:35 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 19:02:48 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 19:02:48 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 28 19:24:27 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 28 19:24:27 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:09 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:09 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:10 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:10 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:11 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:11 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:14 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:14 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:15 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:15 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:17 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:17 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:20 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:20 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:23 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:23 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:28 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:28 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:34 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:34 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:36 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:36 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:57 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:57 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:58 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:58 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:58 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:58 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:25:59 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:25:59 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:26:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:26:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:26:04 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:26:04 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:26:06 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:26:06 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:26:06 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:26:06 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:26:12 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:26:12 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:26:20 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:26:20 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 06:26:55 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 06:26:55 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 08:13:15 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 08:13:15 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 11:22:05 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 29 11:22:05 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 29 19:18:55 haze kernel: MCE: The hardware reports a non fatal,
correctable incident occurred on CPU 0.
Mar 30 06:25:02 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:02 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:09 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:09 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:12 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:12 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:24 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:24 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:28 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:28 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:36 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:36 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:37 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:37 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:40 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:40 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:41 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:41 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:53 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:53 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:25:58 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:25:58 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:00 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:00 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:04 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:04 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:04 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:04 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:06 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:06 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:28 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:28 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:29 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:29 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:38 haze kernel: ata1: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:38 haze kernel: ata1: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:44 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:44 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:26:59 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:26:59 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 06:27:11 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 06:27:11 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 10:13:30 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 10:13:30 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 12:25:31 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 12:25:31 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 16:18:52 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 16:18:52 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 30 16:34:59 haze kernel: ata1: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 30 16:34:59 haze kernel: ata1: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:03 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:03 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:04 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:04 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:10 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:10 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:16 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:16 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:17 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:17 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:20 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:20 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:21 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:21 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:26 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:26 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:28 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:28 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:28 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:28 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:25:28 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:25:28 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:02 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:02 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:08 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:08 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:14 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:14 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:20 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:20 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:29 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:29 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:30 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:30 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:46 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:46 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:47 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:47 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }
Mar 31 06:26:51 haze kernel: ata2: no sense translation for op=0x28
cmd=0x25 status: 0x51
Mar 31 06:26:51 haze kernel: ata2: status=0x51 { DriveReady SeekComplete
Error }

-- 

