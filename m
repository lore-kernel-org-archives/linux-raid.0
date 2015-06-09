From: Pierre Wieser <pwieser@trychlos.org>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 9 Jun 2015 20:46:12 +0200 (CEST)
Message-ID: <1222347192.1017.1433875572719.JavaMail.zimbra@wieser.fr>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr> <55767860.5000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55767860.5000803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

---- Original Message -----
> On 08/06/15 21:28, Pierre Wieser wrote:
> > Hi all,
> > 
> > I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> > I wonder if it would be possible to migrate it to a bigger RAID 5
> > with 3 x 6TB new disks.
> 
> I'd recommend against it:
> 
> https://en.wikipedia.org/wiki/RAID#Unrecoverable_read_errors_during_rebuild

Oop's! I was not conscious at all of this issue. It happens that I am currenly
living dangerously as I have another RAID 5 11,5 TB device :( I had already
seen various administration issues when the size increases to this level, but
I tought this was only an issue regarding the volumes organization (not tought
deeply enough, obviously)....

Starting from your link, and searching a bit, I understand now that the 10TB
is a maximal limit for desktop-grade disks (regarding the URE at least). And
thus for any element of a RAID device which needs to be scanned at recovery
time.
Apart from my poor english, would you say I'm right with this ?

Does linux-raid have any recommandation(s) when managing more than 10TB of data ?

I may imagine:
- several smaller RAID 5 devices
- would RAID10 be a valuable solution in your opinion ?

(as a precision, all my servers have been migrated to CentOS 7.1)

Nonetheless, I thank you very much for the link, which may prevent me to
lose a big bunch of data !

> Jan
> 
Pierre
