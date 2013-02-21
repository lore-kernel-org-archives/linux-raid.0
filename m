From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 15:20:19 -0700
Message-ID: <7C887473-22AB-426D-999E-8F12971B3E6D@colorremedies.com>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51264C18.8000201@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: Phil Turmel <philip@turmel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 21, 2013, at 9:32 AM, Stone <stone@heisl.org> wrote:
>>> 
> This is my ouput from the badblocks
> 1073006628
> 1073006629
> 1073006630
> 1073006631
> 1073006632
> 1073006633
> 1073006634
> 1073006635
> 1073006636
> 1073006637
> 1073006638
> 1073006639

It's consistently reporting 12. This can't be LBA values if it's an AF disk, or you'd get multiples of 8 (8*512=4096). I actually don't recall off hand how to convert from ext block numbers to LBA. But dd wants LBA.

I haven't read this whole thread, is there a backup? I did see more than one disk with non-zero current pending sector values. So in my opinion, I'd ATA secure erase all of these drives and start from scratch if you have a backup. Actually, I'd ATA Secure Erase them, and then do an extended SMART test to confirm. Or if they're under warranty, RMA them. You shouldn't have so much bad sectors on a disk.

If you keep them, you need to keep an eye on them with an extended smart test every week or two. It sounds like there may be loose material bouncing around in the disks causing these bad sectors, and if that's true, more will go bad. And if more do show up in an extended smart test, and the drives are under warranty, I'd bail out on them. Get them replaced.

Chris Murphy