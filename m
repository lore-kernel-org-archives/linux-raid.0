From: Luca Berra <bluca@comedia.it>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Mon, 9 Nov 2009 22:27:05 +0100
Message-ID: <20091109212705.GA29754@maude.comedia.it>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com> <4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com> <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se> <4AF8847D.8030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AF8847D.8030303@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 09, 2009 at 04:07:09PM -0500, Doug Ledford wrote:
>overwrite the superblock), I wouldn't make it 1.2 for whole disk
>devices, and in fact it might be wise to refuse to create 1.2
>superblocks on whole disk devices.  Just a thought.
I am against refusing to do things because users could get confused,
I could agree if this would require a force flag, but not deny
completely.
I would think 1.1 is a good option for default. Better than 1.0 for
reasons we discussed to boredom, and 1.2 is really only for special
cases.
i also agree on the default chunk size bump


-- 
Luca Berra -- bluca@comedia.it
          Communication Media & Services S.r.l.
   /"\
   \ /     ASCII RIBBON CAMPAIGN
    X        AGAINST HTML MAIL
   / \
