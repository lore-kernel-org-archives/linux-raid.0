From: Luca Berra <bluca@comedia.it>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Fri, 22 Nov 2002 00:35:47 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021121233546.GB23949@percy.comedia.it>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au> <20021120160259.GW806@nic1-pc.us.oracle.com> <15836.7011.785444.979392@notabene.cse.unsw.edu.au> <20021121014625.GA14063@redhat.com> <20021121193424.GB770@nic1-pc.us.oracle.com> <20021121195406.GF14063@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021121195406.GF14063@redhat.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 21, 2002 at 02:54:06PM -0500, Doug Ledford wrote:
>is wrong.  There *should* be no md superblocks, there should only be dm 
>superblocks on LVM physical devices and those DM superblocks should 
>include the data needed to fire up the proper md module on the proper 
>physical extents based upon what mapper technology is specified in the 
>DM superblock and what layout is specified in the DM superblock.  In my 
there are no DM superblocks, DM only maps sectors of existing devices
into new (logical) device. the decision of which sectors should be
mapped and where rests in user-space be it LVM2, dmsetup, EVMS or
whatever.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
