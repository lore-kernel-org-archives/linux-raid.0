From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Can't mount Old RHEL 6 Raid with new install of CentOS 7, now
 can't mount with original RHEL 6
Date: Thu, 11 Aug 2016 20:38:41 -0600
Message-ID: <CAJCQCtQfBjhKh2Fu+W76JyXODFJJ9Qxjbyn7KK0i3ALs1xREgQ@mail.gmail.com>
References: <42cee2e2d85a5b0e39efc34117e597a2@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42cee2e2d85a5b0e39efc34117e597a2@celticblues.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Dawson <linux@celticblues.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 11, 2016 at 6:19 AM, John Dawson <linux@celticblues.com> wrote:
> I have a machine which had a drive with RHEL 6.X installed with a raid
> device setup on separate disk(s).  Installed a new hard disk in machine and
> installed CentOS 7.  CentOS 7 wouldn't mount the raid.  Put the old drive
> back in and now RHEL 6.X won't mount the raid.  Is the raid permanently
> hosed?  Can I get the data on it back? How? Thx.

RHEL comes with a support contract so you should contact Red Hat about
that part.

Also, not anywhere near enough information has been provided, almost
like you think what you're experiencing is a widely known problem with
a known solution. But it isn't. So you should provide mdadm -E
information for each member block device, whether or not the array
assembles manually, if not what error do you get in user and kernel
space, and what command you're using to mount the array that you say
fails, and what the error message is.

Also include mdadm version on both systems because few people will
have any idea what mdadm version is on the particular installation of
RHEL and CentOS you're using, as these things aren't standardized at
all across distros.

-- 
Chris Murphy
