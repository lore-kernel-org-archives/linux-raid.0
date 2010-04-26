From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes
Date: Mon, 26 Apr 2010 14:43:58 -0400
Message-ID: <4BD5DEEE.7020208@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com> <4BD5D20B.9020900@cfl.rr.com> <4BD5D5F7.208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD5D5F7.208@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/26/2010 2:05 PM, Doug Ledford wrote:
> So, the point of raid is to be as reliable as possible, if the disk that
> was once gone is now back, we want to use it if possible.

No, we don't.  I explicitly removed that disk from the array because I
have no wish for it to be there any more.  Maybe I plan on using it in
another array, or maybe I plan on shreding its contents.  Whatever I'm
planning for that disk, it does not involve it being used in a raid
array any more.

> The problem is the cause of this thread, and it's a bug that should be
> fixed, it should not cause us to require things to have an explicit
> --add --force to use a previously failed drive.  This is a case of

Then when the drive fails it should only be marked as failed, not also
removed.  If I manually remove it, then it should stay removed until I
decide to do something else with it.

> The md raid stack makes no distinction between explicit removal or a
> device that disappeared because of a glitch in a USB cable or some such.
>  In both cases the drive is failed and removed.  So the fact that you

Then that's the problem.  If it fails, it should be marked as failed.
If it is removed, it should be marked as removed.  They are two
different actions, that should have different results.  Why on earth the
two flags seem to always be used together is beyond me.
