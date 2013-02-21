From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 08:29:27 -0500
Message-ID: <51262137.3040609@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5125EBFD.3050802@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: "stone@heisl.org" <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 04:42 AM, stone@heisl.org wrote:

> i think this is the right way -> dd if=/dev/zero of=/dev/sdc1 bs=4096
> count=1 seek=1073006628 (result of badblocks in my case 48 piece's)?

Yes, but for safety when typing a command line, I always put of= last.
Just in case I hit the <enter> key accidentally:

> dd if=/dev/zero bs=4096 count=1 seek=1073006628 of=/dev/sdc1

>> and this for all badblocks?

Yes.

You should double-check the filesystem blocksize--it is usually 4096 but
ext4 allows you to change it.  "fsck -n" will report the total size of
the filesystem in its blocks.  Divide that into the total size of the
device to get the block size.

Phil

