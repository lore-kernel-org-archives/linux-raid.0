From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID 1 | Restore based on Image of /dev/sda
Date: Mon, 4 May 2020 12:59:47 +0200
Message-ID: <838c9c29-4256-40e1-8c49-12eba590b749@thelounge.net>
References: <5e29b897-b2df-c6b9-019a-e037101bfeec@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5e29b897-b2df-c6b9-019a-e037101bfeec@peter-speer.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 04.05.20 um 12:48 schrieb Stefanie Leisestreichler:
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

mdadm /dev/mdX --add /dev/sdx{1,2}
