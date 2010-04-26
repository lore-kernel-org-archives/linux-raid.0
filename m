From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: safe segmenting of conflicting changes
Date: Mon, 26 Apr 2010 13:48:59 -0400
Message-ID: <4BD5D20B.9020900@cfl.rr.com>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <4BD1E491.3090603@cfl.rr.com> <4BD5C65B.7080707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD5C65B.7080707@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/26/2010 12:59 PM, Doug Ledford wrote:
>> This goes ahead and adds the disk back to the array, despite the fact
>> that it has been explicitly removed.
> 
> Of course it does.  You've just explicitly readded it, which is no
> different than your explicit removal.  Mdadm honors both.

No, --incremental is automatically invoked by udev to scan disks as they
are detected and try to assemble them.  It isn't an explicit --add
operation.

>> Whether or not the superblock on sdb is updated when it is removed,
>> --incremental should NOT use it as long as mdadm -D /dev/md0 says that
>> disk is removed, at least not use it in /dev/md0.
> 
> Why not?  It's not like it uses it without correcting the missing bits
> first.  My guess is that you've either A) got a write intent bitmap or

Actually under the right circumstances it DOES use the second disk's
incorrect data without correcting it first, and if it does overwrite it,
that causes data loss so should not be done without an explicit --add
--force.  The fact that this happens is the entire reason for this thread.

Whether or not it can be added safely, the disk has been explicitly
removed so automatically adding it back is not acceptable.

