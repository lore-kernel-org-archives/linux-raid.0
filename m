From: Brad Campbell <brad@wasp.net.au>
Subject: Re: A failed-disk-how-to anywhere?
Date: Sun, 09 Apr 2006 18:19:50 +0400
Message-ID: <44391806.3000200@wasp.net.au>
References: <C1F5413C-E9AB-4331-A901-1FBB645719DF@stender.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C1F5413C-E9AB-4331-A901-1FBB645719DF@stender.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Stender <martin@stender.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin Stender wrote:
> Hi there!
> 
> I have two identical disks sitting on a Promise dual channel IDE 
> controller. I guess both disks are primary's then.
> 
> One of the disks have failed, so I bought a new disk, took out the 
> failed disk, and put in the new one.
> That might seem a little naive, and apparently it was, since the system 
> won't boot up now.
> It boots fine, when only the old, healthy disk is connected.
> 
> By the way, all three partitions are raided - including /boot ...
> 
> Anyway, I have removed the old disk from the Raid with:
> #mdadm /dev/mdo --remove /dev/hde1
> #mdadm /dev/md1 --remove /dev/hde2
> #mdadm /dev/md2 --remove /dev/hde3
> 
> - but the the problem persists.
> 
> I can't seem to find a decent 'How-To' - so how it this supposed to be 
> done?

A little more info would be helpful. How does the machine boot? How are your other disks configured?
Are you booting off the Promise board or on-board controller (making assumptions given your promise 
appears to contain hde, I'm assuming hd[abcd] are on board somewhere..)

I'm going to take a wild stab in the dark now..

My initial thought would be you have hde and hdg in a raid-1 and nothing on the on-board 
controllers. hde has failed and when you removed it your controller tried the 1st disk it could find 
(hdg) to boot of.. Bingo.. away we go.
You plug a new shiny disk into hde and now the controller tries to boot off that, except it's blank 
and therefore a no-go.

I'd either try and force the controller to boot off hdg (which might be a controller bios option) or 
swap hde & hdg.. then it might boot and let you create your partitions on hdg and then add it back 
into the mirror.

How close did I get ?


Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
