From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: enhancements to the raid1 driver
Date: Mon, 17 Feb 2003 15:09:16 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E51416C.2E7E92D@SteelEye.com>
References: <3E4D96DB.7AC5954B@SteelEye.com> <15952.20020.858737.543347@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, jejb@SteelEye.com
List-Id: linux-raid.ids

Neil,

Neil Brown wrote:
> Maybe if you explain more about what would be the specifics of these
> ioctls that you want to pass down.

Sure, no problem...
 
> > asynchronous replication - to get acceptable performance when the backup
> > leg of the raid1 mirror is slow (e.g., nbd over a LAN or WAN)
> 
> Hmmm. I cannot figure out exactly what would be asynchronous...  Nor
> can I see how this would require an ioctl.

Basically, we're trying to overcome latency penalties associated with
writing data and waiting for acknowledgements over a network (or any
other slow transport). So, all writes to the backup device(s) would be
queued, so that the writes could take place asynchronously. The size of
the queue and whether or not to enable this asynchronous mode would be
user-configurable; that's where the ioctls come in. Since user
configuration of the md driver is currently done with ioctls, this
seemed like the natural choice. Of course, I'm open to other
suggestions, if there's a better way to do this...

--
Paul
