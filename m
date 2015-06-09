From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 09 Jun 2015 07:23:44 +0200
Message-ID: <55767860.5000803@gmail.com>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Wieser <pwieser@trychlos.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/06/15 21:28, Pierre Wieser wrote:
> Hi all,
> 
> I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> I wonder if it would be possible to migrate it to a bigger RAID 5
> with 3 x 6TB new disks.

I'd recommend against it:

https://en.wikipedia.org/wiki/RAID#Unrecoverable_read_errors_during_rebuild

Jan

