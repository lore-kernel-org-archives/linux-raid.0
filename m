From: David Greaves <david@dgreaves.com>
Subject: Re: sata controllers status=0x51 { DriveReady SeekComplete Error
 } error=0x84 { DriveStatusError BadCRC }
Date: Sat, 01 Apr 2006 12:52:45 +0100
Message-ID: <442E698D.8000100@dgreaves.com>
References: <200603301051.31551.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200603301051.31551.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:

>Hi,
>
>I have a production server in place at a remote site. 
>I have a single system drive that is an ide drive 
>and two data drives that are on a via SATA controller in a raid1 
>configuration.
>
>I am monitoring the /var/log/messages and I get messages every few days
>
>Mar 22 23:31:36 A1 kernel: ata6: status=0x51 { DriveReady SeekComplete Error }
>Mar 22 23:31:36 A1 kernel: ata6: error=0x84 { DriveStatusError BadCRC }
>
>Mar 23 23:20:12 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete Error }
>Mar 23 23:20:12 A1 kernel: ata5: error=0x84 { DriveStatusError BadCRC }
>Mar 23 23:32:03 A1 kernel: ata6: status=0x51 { DriveReady SeekComplete Error }
>Mar 23 23:32:04 A1 kernel: ata6: error=0x84 { DriveStatusError BadCRC }
>
>Mar 24 23:22:45 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete Error }
>Mar 24 23:22:45 A1 kernel: ata5: error=0x84 { DriveStatusError BadCRC }
>
>
>Mar 27 23:16:57 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete Error }
>Mar 27 23:16:57 A1 kernel: ata5: error=0x84 { DriveStatusError BadCRC }
>
>Mar 28 23:10:16 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete Error }
>Mar 28 23:10:17 A1 kernel: ata5: error=0x84 { DriveStatusError BadCRC }
>Mar 28 23:23:32 A1 kernel: ata6: status=0x51 { DriveReady SeekComplete Error }
>Mar 28 23:23:32 A1 kernel: ata6: error=0x84 { DriveStatusError BadCRC }
>
>
>Mar 29 23:33:26 A1 kernel: ata6: status=0x51 { DriveReady SeekComplete Error }
>Mar 29 23:33:26 A1 kernel: ata6: error=0x84 { DriveStatusError BadCRC }
>  
>
Look here:

http://marc.theaimsgroup.com/?l=linux-kernel&m=114386015009790&w=2

I don't know he's right - you may want to get into it...

David

