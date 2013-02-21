From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 08:15:02 -0500
Message-ID: <51261DD6.9040009@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5125C6E9.4050802@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 02:04 AM, Stone wrote:

> Ok i have now a list of my badblocks.
> Now i fix them with dd
> dd if=/dev/zero of=/dev/sdc1 bs=1073006628 cout=1
> and this for all badblocks?
> 
> with this command i fill the badblocks with a null but override data? i
> cannot damage my data with this or?

This will destroy a large part of your disk.  :-(

But you've already figured that out...
