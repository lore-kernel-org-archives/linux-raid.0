From: Luca Berra <bluca@comedia.it>
Subject: Re: Proposed enhancements to MD
Date: Tue, 13 Jan 2004 23:42:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040113224255.GK26643@percy.comedia.it>
References: <40033D02.8000207@adaptec.com> <40043C75.6040100@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40043C75.6040100@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Scott Long <scott_long@adaptec.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On Tue, Jan 13, 2004 at 01:44:05PM -0500, Jeff Garzik wrote:
>And I could have _sworn_ that Neil already posted a patch to do 
>partitions in md, but maybe my memory is playing tricks on me.
he did, and a long time ago also.
http://cgi.cse.unsw.edu.au/~neilb/patches/

>IMO, your post/effort all boils down to an open design question:  device 
>mapper or md, for doing stuff like vendor-raid1 or vendor-raid5?  And it 
>is even possible to share (for example) raid5 engine among all the 
>various vendor RAID5's?
I would believe the way to go is having md raid personalities turned
into device mapper targets.
the issue is that raid personalities need to be able to constantly
update the metadata, so a callback must be in place to communicate
`exceptions` to a layer that sits above device-mapper and handles
metadatas.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
