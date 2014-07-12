From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Fri, 11 Jul 2014 19:09:48 -0600
Message-ID: <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com>
References: <53C06815.2020302@dobrotescu.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C06815.2020302@dobrotescu.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Vlad Dobrotescu <vlad@dobrotescu.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jul 11, 2014, at 4:41 PM, Vlad Dobrotescu <vlad@dobrotescu.ca> wrote:
> 
> 6. mdadm on top of LVM2 LGs (not the other way around): would there be any issues or performance penalties?

You're not assured what PV the LV's are located on. So those 6 LVs you're using as md members might not be on six physical devices. One drive dies, you can lose the whole array. You're better off using LVM raid, or doing things conventionally by first creating the md raid set and then making the md logical device a PV.

> 
> 7. I am sure I read somewhere (can't find the source anymore) that the "new" RAID features of LVM2 are based on a fork from the md code. If this is true, are you guys are contributing to that project as well?

It's a good question, I'm not certain but my understanding is device mapper is leveraging existing md code in the kernel, rather than having forked and duplicated that code. They have their own user space tools and on-disk metadata so you can't use mdadm to manage it.


Chris Murphy