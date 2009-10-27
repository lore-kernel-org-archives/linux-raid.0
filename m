From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 14:05:00 -0700 (PDT)
Message-ID: <692464.27699.qm@web38806.mail.mud.yahoo.com>
References: <7d86ddb90910271400m6d0c5a76n7af4d99bedf66bfc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90910271400m6d0c5a76n7af4d99bedf66bfc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 10/27/09, Ryan Wagoner <rswagoner@gmail.com> wrote:
> I think you are way over complicating this. NFS would do
> this with a single line

Well, with sshfs no lines/thinking allowed, assuming SSH is set up properly.  Just in fstab:
sshfs#bill@hex:/	/media/hex	fuse	user,auto,gid=6,umask=007,cache=no,ServerAliveInterval=15,reconnect,allow_other,comment=sshfs 0 0
... and any remote disk is mounted automatically on boot, served through a military-grade encrypted tunnel.  I have no time to learn all the security implications of NFS and pals.

I'm just trying to help the heathens...


      
