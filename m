From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes
Date: Wed, 28 Apr 2010 09:22:20 -0400
Message-ID: <4BD8368C.2050505@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com> <4BD5E477.2010201@redhat.com> <4BD5EBC0.9030801@cfl.rr.com> <4BD622DC.7030309@redhat.com> <4BD70ECE.3090200@cfl.rr.com> <4BD71E9D.1040206@redhat.com> <4BD7272D.3040500@cfl.rr.com> <4BD73B1B.8060204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD73B1B.8060204@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/27/2010 3:29 PM, Doug Ledford wrote:
> We do record it, but mainly in the form of our disk count.  We keep
> track of active discs, failed discs, and spare discs.  Whether we have
> the disc open and in our device list changes what our failed disc count
> would be.  On removal, we decrement that failed disc count.  The slot
> that the disc used to occupy gets changed from being failed to removed
> simply to indicate there is no rdev associated with that slot.  That is
> the information we record.

Why bother recording that?  Whether or not the kernel last had an rdev
open is useless information to have in the superblock.  Why not instead
leave it recorded as failed until --removed?

> You are making assumptions about the use of that bit.  We don't ignore
> it, we just don't use it the way you think we should.

Then how is it used, because I see no way in which the kernel cares
whether or not the kernel had a given device open or not prior to a crash.

> Sure you can: mdadm /dev/md0 -a /dev/sdc1

That's add, not re-add.
