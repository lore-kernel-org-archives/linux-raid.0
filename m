From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: Preparation advice?
Date: Sat, 27 Nov 2004 15:39:37 -0500
Message-ID: <6d5bedd8041127123945b8db48@mail.gmail.com>
References: <6d5bedd8041126205255c0fe7d@mail.gmail.com>
	 <Pine.LNX.4.56.0411270837340.5805@lion.drogon.net>
	 <6d5bedd8041127082528ce68ec@mail.gmail.com>
	 <41A8C57A.1060803@dgreaves.com>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41A8C57A.1060803@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 27 Nov 2004 18:20:42 +0000, David Greaves <david@dgreaves.com> wrote:
> 
> >Created a mount point /mnt/md0, but do I edit /etc/fstab or another
> >file since fstab seems to be generated on boot?
> >
> >
> edit /etc/fstab

Well, I must be missing this at the FAQ sites, but when I edit
/etc/fstab do I leave the entries in for the component devices, or do
I remove those and just put in the /dev/md0 entry?

Thanks again,
Ewan
