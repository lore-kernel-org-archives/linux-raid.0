From: adfas asd <chimera_god@yahoo.com>
Subject: Re: NAS Remote Side of a Mirror
Date: Thu, 8 Oct 2009 06:39:23 -0700 (PDT)
Message-ID: <63439.16521.qm@web38808.mail.mud.yahoo.com>
References: <4ACDE4B3.7000007@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ACDE4B3.7000007@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Thu, 10/8/09, John Robinson <john.robinson@anonymous.org.uk> wrote:
> In which case no, you don't need Samba, you never did need
> Samba and I've no idea why you were using it.

I used Samba because it was the only alternative to that NFS bloatware in the Olden Days.  Then I graduated into the 21st century and have used FUSE (sshfs) ever since.


--- On Thu, 10/8/09, John Robinson <john.robinson@anonymous.org.uk> wrote:
> The QNAP NAS you linked to does export filesystems via SMB
> using Samba, as well as via AFS, NFS, FTP and HTTP. It can
> also export volumes via iSCSI. It almost certainly runs LVM
> over md RAID to do all these things.

It's looking like iSCSI is the ticket as it can write directly to SCSI buffers using iSER. (http://en.wikipedia.org/wiki/ISCSI_Extensions_for_RDMA) No hardware needed, just some kernel modules.  This, barring some find in FUSE Networked Filesystems. (http://sourceforge.net/apps/mediawiki/fuse/index.php?title=NetworkFileSystems)

FUSE is amazing.  Just look at these encrypted filesystem options:
 http://sourceforge.net/apps/mediawiki/fuse/index.php?title=EncryptedFileSystems
... Needless to say, these may be too slow for RAIDing, but it just shows the depth of FUSE.

But I can not understand where LVM would come into play with the Qnap?  Why?

 



      
