From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID Recovery
Date: Tue, 7 Mar 2017 10:00:00 -0500
Message-ID: <1066d485-ebea-d0d2-a198-33b560de99fc@turmel.org>
References: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
 <e4d9724d-ab52-aa79-c600-7b287c16a182@turmel.org>
 <7cefe670-dcea-6e04-b090-b215a6a218c9@websitemanagers.com.au>
 <94b4591a-bda1-529b-3af1-c451b657082f@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <94b4591a-bda1-529b-3af1-c451b657082f@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Adam,

{Please remember to trim repetitive stuff, and interleave.}

On 03/07/2017 09:06 AM, Adam Goryachev wrote:
> BTW, just some more info I've found... either almost the entire
> drives are RAID1 mirrors, or all 4 are RAID1 mirrors:

> Other option, they have been re-initialised/zero'd or similar, and
> thats why all the data is identical (useless). I was hoping to get a
> starting point for where the partition boundaries might have been
> ....

Search the devices for ext2/3/4 superblocks, like so:

dd if=/dev/sdX bs=1M 2>/dev/null |hexdump -C |grep '30  .\+  53 ef 0'

This will take a very long time, and will generate false positives.
You probably would want to use screen or tmux to run these in
parallel in separate processes.

But superblock locations will give you hints as to the rest of data,
and make it possible to create partitions that will let you copy
stuff off into a new array.

Phil
