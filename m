From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have failed.
Date: Tue, 19 Mar 2013 14:14:56 -0500
Message-ID: <253A705A-C2DA-4E02-BEF9-66FBCD5ABB28@redhat.com>
References: <32480862.0.1363627869379.JavaMail.root@zimbra>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32480862.0.1363627869379.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 18, 2013, at 12:31 PM, Roy Sigurd Karlsbakk wrote:

>>> Are other people seeing this, or is this an artifact of the way I am
>>> killing devices ('echo offline > /sys/block/$dev/device/state')?
>> 
>> That is a perfectly good way to kill a device.
> 
> Anyone that knows what may have replaced this in 3.8, or if this isn't available for virtio devices? I have a vm on 3.8 (ubuntu raring alpha/beta/something), and I find no such file there. Works great on the host OS, though (ubuntu precise, linux 3.2).

I'm using this specifically on 3.8+.  I'm not using VMs at the moment, but in the past it has been available there - not for partitions and loopback devices though.

 brassow