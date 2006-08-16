From: andy liebman <andyliebman@aol.com>
Subject: Re:  Imaging Mirrored OS Drive
Date: Wed, 16 Aug 2006 15:02:42 -0400
Message-ID: <44E36BD2.20707@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Sorry, I EOF'd too soon..
> As to creating mirrored partitions over top of existing data, mdadm will write a \
> superblock at the beginning of each mirrored component, which will blow up the first \
> several bytes of the partition (probably the FS descriptor). I believe there is an \
> option to create a raid1 pair without a superblock, but I don't think I would want to \
> use it.
>   
Well, I created new mirrors on top of the existing partition pairs, and 
specified the UUID for each device(so that they were the same as the old 
mirrored partition pairs) and the system booted up fine. I'm going to 
run e2fsck on the md devices (booting again in a Live CD) to see if 
there's any corruption.

I'm actually kind of surprised the system booted up.

Can anybody suggest other tests to run to see if things really ARE okay? 
Should one be able to do what I just did?

Andy
