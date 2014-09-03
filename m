From: Xiao Ni <xni@redhat.com>
Subject: Re: Will the write request starve?
Date: Wed, 3 Sep 2014 04:18:05 -0400 (EDT)
Message-ID: <1479973778.31875924.1409732285639.JavaMail.zimbra@redhat.com>
References: <1482714710.31831797.1409723948805.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1482714710.31831797.1409723948805.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: linux-raid@vger.kernel.org
> Cc: "jes sorensen" <jes.sorensen@redhat.com>
> Sent: Wednesday, September 3, 2014 1:59:08 PM
> Subject: Will the write request starve?
> 
> Hi all
> 
>    I meet a problem and I can't find the answer. Could you help me?
> When raid5d want to handle a request, it need to get stripes by
> __get_priority_stripe.
> In the __get_priority_stripe function, it always try to get stripe from
> handle_list.
> 
>    Make an assumption that the raid of level 5 is assembled with 4 disks, and
>    the raid
> is normal. Now the a write request just want to write a single chunk, so we
> choose RMW

Sorry, it'll choose RCW

> and the stripe will put on the delay_list, then activate it and put it to
> hold_list.
> But if there are many read requests after the write request, when raid5d
> handle stripes
> it will get stripe from handle_list. So will the write request starve?
> 
>    Certainly I know it will not, because many tests have been done. But I
>    can't find
> the reason why it will not starve.
> 
>    And there is a variable bypass_count, what's the function about it? If
>    bypass_count <
> bypass_threshold, it can get a chance to wait for the next write request to
> get a full write.
> So avoid read requests. Am I right?
> 
> Best Regards
> Xiao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
