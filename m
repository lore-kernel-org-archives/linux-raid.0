From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 10:38:38 -0500
Message-ID: <51263F7E.7040207@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51263D9D.1080002@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: "stone@heisl.org" <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 10:30 AM, stone@heisl.org wrote:

> dd if=/dev/zero bs=4096 count=1 seek=1073006628 of=/dev/sdc1
> dd: `/dev/sdc1': cannot seek: Invalid argument
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0,000493485 s, 0,0 kB/s
> 
> is there a problem with the bs parameter?
> shoud i try dd if=/dev/zero bs=512 count=8 seek=1073006628 of=/dev/sdc1
> ?

How did you get 1073006628?  That is around the 4T mark?

Please show the badblocks output file.

Phil

