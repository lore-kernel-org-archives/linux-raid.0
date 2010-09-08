From: Neil Brown <neilb@suse.de>
Subject: Re: 5 drives lost in an inactive  15 drive raid 6 system due to
 cable problem - how to recover?
Date: Thu, 9 Sep 2010 07:35:30 +1000
Message-ID: <20100909073530.1e5da34d@notabene>
References: <4C87C656.2030405@stern.nyu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C87C656.2030405@stern.nyu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Norman White <nwhite@stern.nyu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 08 Sep 2010 13:22:30 -0400
Norman White <nwhite@stern.nyu.edu> wrote:

> We have a 15 drive addonics array with 3 5 port sata multiplexors, one 
> of the sas cables was knocked out to one of the port multiplexors and now
> mdadm sees 9 drives , a spare, and 5 failed, removed drives (after 
> fixing the cabling problem).
> 
> A mdadm -E on each of the drives, see 5 drives (the ones that were 
> uncabled) as seeing the original  configuration with 14 drives and a 
> spare, while the other 10 drives report
> 9 drives, a spare and 5 failed , removed drives.
> 
> We are very confident that there was no io going on at the time, but are 
> not sure how to proceed.
> 
> One obvious thing to do is to just do a:
> 
> mdadm --assemble --force --assume-clean /dev/md0 sd[b,c, ... , p]
> but we are getting different advice about what force will do in this 
> situation. The last thing we want to do is wipe the array.

What sort of different advice?  From whom?

This should either do exactly what you want, or nothing at all.  I suspect
the former.  To be more confident I would need to see the output of
   mdadm -E /dev/sd[b-p]

NeilBrown


> 
> Another option would be to fiddle with the super blocks with mddump, so 
> that they all see the same 15 drives in the same configuration, and then 
> assemble it.
> 
> Yet another suggestion was to recreate the array configuration and hope 
> that the data wouldn't be touched.
> 
> And even another suggestion is to create the array with one drive 
> missing (so it is degraded and won't rebuild)
> 
> Any pointers on how to proceed would be helpful. Restoring 30TB takes 
> along time.
> 
> Best,
> Norman White
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

