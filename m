From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID 1 | Restore based on Image of /dev/sda
Date: Mon, 4 May 2020 12:07:15 +0100
Message-ID: <5EAFF763.2000906@youngman.org.uk>
References: <5e29b897-b2df-c6b9-019a-e037101bfeec@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5e29b897-b2df-c6b9-019a-e037101bfeec@peter-speer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/05/20 11:48, Stefanie Leisestreichler wrote:
> Hi.
> I have a running RAID 1 based on /dev/sda1 and /dev/sda2 with
> metadata=1.2 with mdadm version 3.2.5.
> 
> I took an image of /dev/sda using dd.
> There is a computer with identical hardware (test-env) where I put in
> this image. When I start this computer, it is booting and recognizing
> the raid active as md0 with state [2/1] [U_] like expected.
> 
> My target is to restore the raid using another new and blank hard disk
> in the test-env computer. I know I have to format the new disk
> identically to the format the image is providing, but I am unsure about
> how to add the new disk to the raid array.
> 
> Could you please guide me?
> 
https://raid.wiki.kernel.org/index.php/Linux_Raid

Is the drive formatted with one big partition? I guess it is. What it
really cares about is that the new partition you are adding is identical
in size to the partition the raid is on.

There are tools that will copy a partition table for you - BEWARE - a
lot of things rely on GUIDs and at least the tools I know of don't reset
them by default - duplicate unique ids are not a good idea :-) So as you
copied this drive using dd DO NOT put it back in the original computer ...

https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm#Adding_a_drive_to_a_mirror

Cheers,
Wol
