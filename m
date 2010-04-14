From: James Braid <jamesb@loreland.org>
Subject: Re: grow fails with 2.6.34 git
Date: Thu, 15 Apr 2010 00:27:51 +0100
Message-ID: <hq5j1n$3os$1@dough.gmane.org>
References: <hq5efu$mqb$1@dough.gmane.org> <v2p4877c76c1004141548m6d3da932hd14543da1b730af9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <v2p4877c76c1004141548m6d3da932hd14543da1b730af9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans wrote:
> Yes, that /extremely/ slow growth progress is normal for this
> conversion.  Every critical section must be backed up synced, and only
> then will it proceed.  You may notice an incorrect number of disks
> relative to the expected number.  That will go away the next time the
> array is assembled.

Thanks. I'm not concerned about the speed; the fact that I had to stop 
and restart the array before the reshape would begin is what concerns 
me, as well as the odd sysfs errors.

