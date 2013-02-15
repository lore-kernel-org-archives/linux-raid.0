From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Best practice for large storage?
Date: Thu, 14 Feb 2013 19:18:36 -0700
Message-ID: <68736BCF-23AB-4546-8F2A-DF8E43E8222D@colorremedies.com>
References: <24358517.18.1360862926919.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24358517.18.1360862926919.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 14, 2013, at 10:28 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:

> This is a 20k studen college
>  large amounts of raw material
> 50-100TiB, perhaps more
> I guess nearline SAS drives
> I won't be using a single RAID-6 (too insecure) or RAID-10 (too expensive)

This could be a case for GlusterFS or Ceph.  You might look at those groups and see what they'd suggest for your use case. Even if it doesn't make sense right away, it might make sense sooner than later in which case it's good to have an initial deployment that doesn't make it a hassle to move to Gluster when you're ready.

Stan makes a good case for SAS HBA's capable of doing RAID, they're inexpensive, fast, reliable, you get support, and they don't cost really any more than the HBA you need anyway to connect all of these drives. Definitely use XFS for the resulting arrays. Then hand those over to GlusterFS as storage bricks (Ceph has a different arrangement and terms).

You can inquire if the GlusterFS NFS client is suitable for this task if the clients are Windows or Mac; or if it's better to setup one or more NFS v4 servers which are themselves using the native GlusterFS client. It likely depends on network bandwidth (for video 10GigE is common), how many clients, etc. Gluster also scales well in performance and capacity, just add more bricks. And you won't need to bust the drive cap in your arrays, or stripe them.

As storage gets really big, the risk of non-drive failures increases to the point that needs to be mitigated. And that's what a distributed file system will help you do.

Chris Murphy