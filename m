From: Michal Soltys <soltys@ziu.info>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Thu, 28 Jul 2011 14:53:36 +0200
Message-ID: <4E315BD0.7040400@ziu.info>
References: <20110727141652.7511fc51@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110727141652.7511fc51@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 27.07.2011 06:16, NeilBrown pisze:
>
> If you create an array with this mdadm it will add a bad block log - you
> cannot turn it off (it is only 4K long so why would you want to).  Then as
> errors occur they will cause the faulty block to be added to the log rather
> than the device to be remove from the array.

I was wondering, 4KiB is "just" 512 entries assuming these are only 
64bit sector addresses - it's possible to imagine a failing drive with 
lots of not reloctable (for whatever reason) adjacent sectors, that 
could fill up the log relatively quickly (mentioned 512 entries ~ 256KiB 
worth of data on 512b drives, just a few chunks before the drive is 
kicked out). Though - how realistic such scenario is with modern drives, 
is hard for me to judge.

Still - are there any plans to make that 4KiB size not hardcoded, also 
perhaps along with customizable offset to the 1st chunk ?

Something of analogous functionality to lvm's options such as:

--metadatasize
--dataalignment
--dataalignmentoffset

(though again, hard to judge if there's any practical use for those 
aside exotic scenarios)

