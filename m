From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes
Date: Mon, 26 Apr 2010 15:38:40 -0400
Message-ID: <4BD5EBC0.9030801@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com> <4BD5DEEE.7020208@cfl.rr.com> <4BD5E477.2010201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD5E477.2010201@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/26/2010 3:07 PM, Doug Ledford wrote:
> Then you need to remove the superblock from the device.

Why?  It has been removed.  In English removed means it is no longer
part of the array.  Elements which are not part of the array should not
be MADE part of the array just because they happen to be there.

Having to zero the superblock after failing and removing the drive is a
race condition with detecting the drive and automatically adding it back
to the array.  To properly remove the disk from the array the superblock
needs to be updated before the kernel releases the underlying device.

> The problem here seems to be an issue of expectations.  You think that
> "removed" is used as a flag to record intent, where as it actually is
> nothing more than a matter of state.

No, I don't think it has anything to do with intent.  I think that the
state of being removed means it is no longer part of the array.  It
sounds like your understanding of the state should be described in
English as detached or disconnected, rather than removed.

> Failed is also a matter of state.  It means the device has encountered
> some sort of error and we should no longer attempt to send any
> read/write commands to the device.  It is not a statement of *why* it's
> in that state.  The removed state indicates that the device has been
> removed from the array and is no longer a slave to the array.  Again, no
> indication of intent or cause, purely an issue of state.

Yes, it does not indicate why, nor do we care.  What we care about is
that the drive failed or was removed, so we should not be using it.  Why
bother recording that fact in the superblock if you're just going to
ignore it the next time you start the array?

