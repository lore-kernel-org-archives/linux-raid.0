From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Help ! Kernel panic: VFS: Unable to mount root fs on 09:01
Date: Thu, 01 May 2003 16:16:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB18094.41F84BAA@SteelEye.com>
References: <002301c31015$8c75e4c0$9affff0a@inpa.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Roberto Samarone Araujo (RSA)" <sama@inf.ufsc.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Roberto Samarone Araujo (RSA)" wrote:

> RAMDISK: Compressed image found at block 0
> invalid compressed format (err=1),6. Freeing initrd memory: 484 freed

Looks like your initrd image got fried...I believe that's where raid1
should have gotten loaded and your array autostarted (if this is United
Linux 1.0/Conectiva)... 

try booting with "linux root=/dev/hda2" at the lilo prompt 

it still might not work though...

good luck...

--
Paul
