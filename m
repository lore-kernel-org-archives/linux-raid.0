From: cvb@kruemel.org
Subject: Re: Is it possible to grow a (far) RAID =?UTF-8?Q?=31=30=3F?=
Date: Tue, 25 Nov 2014 12:01:58 +0100
Message-ID: <81fe7d20d731393c86a6ca557d71adaa@kruemel.org>
References: <54744AEE.10908@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54744AEE.10908@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: linux RAID <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi

Am 2014-11-25 10:25, schrieb Carsten Aulbert:
> Without much thinking, I would simply follow the wiki page, mark a
> device as failed, remove it, repartition it, add it again, and wait
> for sync to complete. Repeat for all 4 devices and finally --grow with
> mdadm (followed by xfs resizing) - and of course, all online, while
> machine is in flight.

That is exactoy what I did with my RAID 10 a bit more than a year ago. 
It basically worked, but there was one caveat... some part (the 
---grow?) which required a certain kernel version for which I had booted 
a live CD back then...

The thing is, I can't exactly remember what the caveat was. And as I'm 
about to grow the RAID again (having replaced all hard drives already), 
I have been looking for the related mails in the archive of this list, 
but I can't seem to find them...

So I guess we'll have to hope that Neil replies again.

Chris
