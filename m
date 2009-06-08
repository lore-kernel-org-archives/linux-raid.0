From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Unable to stop array
Date: Mon, 8 Jun 2009 00:18:41 -0500
Message-ID: <20090608051837666.JOXY14139@cdptpa-omta02.mail.rr.com>
References: <20090608050121.GB6664@boogie.lpds.sztaki.hu>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090608050121.GB6664@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Gabor Gombas
> Sent: Monday, June 08, 2009 12:01 AM
> To: Leslie Rhorer
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Unable to stop array
> 
> On Sun, Jun 07, 2009 at 08:37:47PM -0500, Leslie Rhorer wrote:
> 
> > It seems to me this is reproducible whenever the mount is used for an
> NFS
> > share.  Even after unmounting the share on the remote system, the umount
> > command won't release the mount on the local system unless one issues
> the -l
> > switch, and then the array still won't stop.
> 
> You must unexport the NFS share first. You can not stop the RAID device
> until the file system is unmounted, and you cannot unmount it until the
> NFS export is gone. umount said you the file system is still in use; by
> passing "-l" you said you do not care. But the kernel (including the
> RAID device) _does_ care.

Ah!  Thanks.  `exportfs -ua` did the trick.

