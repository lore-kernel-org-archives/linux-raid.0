From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md array.
Date: Tue, 2 Nov 2004 08:12:59 +0100
Message-ID: <20041102071258.GA9190@percy.comedia.it>
References: <20041102143440.12019.patches@notabene> <E1COpUP-000392-Hw@notabene.cse.unsw.edu.au> <20041101205735.5fc68d69.akpm@osdl.org> <20041101210044.20c4a8e0.akpm@osdl.org> <16775.3329.279178.375487@cse.unsw.edu.au> <20041101213333.201769d0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041101213333.201769d0.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 01, 2004 at 09:33:33PM -0800, Andrew Morton wrote:
>> md has the misfortune of working in a way that doesn't fit very well
>> with some aspects of the blkdev layer.
>> 
>> To create an md array, you open /dev/mdX, and use some ioctls to set
>> up the array.  Thus the block device must exist internally as a block
>> device before any details about it are available.
>> 
>> Similarly, to shut down an array, you open /dev/mdX and use an ioctl
>> to shut it down.  This it will still be open (though only once) after
>> it has been shut down.
>> 
>> (as I understand it) I can only safely use blk_cleanup_queue on the
>> queue after (or during) the last close.  Thus I cannot use it while
>> shutting down an array.
>> However I need to release the md personality as part of shutting down
>> the array, so I have to disable the unplug function (which is handled
>> by the personality).
>> 
>> I could change ->unplug_fn to point to something safe, but there is
>> still a race with the timer going off at just the wrong time.
>
>hm, OK.  So perhaps using /dev/mdX as a control channel for creating and
>destroying /dev/mdX was unfortunate design.  Ho hum.

would it be unfeasible to create a custom (misc) character device, say
/dev/mdadm and use that to control arrays instead of /dev/md0?

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
