From: Neil Brown <neilb@suse.de>
Subject: Re: intent-logging, not synchronizing written blocks?
Date: Thu, 10 Nov 2005 11:37:01 +1100
Message-ID: <17266.38445.331573.338926@cse.unsw.edu.au>
References: <17266.30693.504831.133082@fisica.ufpr.br>
	<17266.32043.52698.717602@cse.unsw.edu.au>
	<17266.37369.974982.901592@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Wednesday November 9
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 9, carlos@fisica.ufpr.br wrote:
> Neil Brown (neilb@suse.de) wrote on 10 November 2005 09:50:
>  >> Is intent-logging for raid5 already in mainline or only in -mm? I
>  >> looked for it in 2.6.14 and found nothing...
>  >
>  >raid5 is in 2.6.14.  raid6 and raid10 should be in 2.6.16.
>  >What did you look for?
> 
> Some doc, or compilation option. I suppose it's always on then and
> just using --re-add with mdadm is enough.

No, you have to tell an md array to use an intent bitmap.
If you can do this to a running array with e.g.
  mdadm --grow --bitmap=internal /dev/md1


> 
>  >I'm not sure what you mean by 'went out of sync'.
> 
> I wasn't clear, I meant a device failed.
> 
>  >When an array is active and being written to, many stripes could be
>  >out-of-sync at any time, as writes have been started, but haven't
>  >completed yet. Intent logging record the intent to write somewhere
>  >before doing the write, and then clears the intent sometime after
>  >the write completes.
>  >
>  >After a crash, some intents will still be recorded, and only the
>  >stripes associated with these risk being out-of-sync, so only those
>  >need to be resynced.
> 
> What about the writes that were started and completed after the
> failure?

If the array is degraded, intents are not removed from the bitmap, so
these writes will still be recorded in the bitmap.

NeilBrown
