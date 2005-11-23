From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Wed, 23 Nov 2005 10:44:36 +0100
Message-ID: <007b01c5f012$89bdebd0$a700a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at><200511272040.47644.a1426z@gawab.com><041e01c5f605$6a7c0830$0400a8c0@dcccs><200512022253.17282.a1426z@gawab.com><00fd01c60367$d8d8f5d0$0400a8c0@dcccs><17320.45715.533255.759042@cse.unsw.edu.au><00fd01c5ef07$f41bf690$a700a8c0@dcccs> <17322.12373.766596.426816@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, December 22, 2005 5:49 AM
Subject: Re: RAID0 performance question


> On Tuesday November 22, djani22@dynamicweb.hu wrote:
> > I have already try the all available options, including readahead in all
> > layer (result in earlyer mails), and chunksize.
> > But with this settings, i cannot workaround this.
> > And the result is incomprehensible for me!
> > The raid0 performance is not equal with one component , with sum of all
> > component , and not equal with the slowest component!
>
> This is quite perplexing.
>
> My next step would probably be to watch the network traffic with
> tcpdump or ethereal.  I would look for any differences between when it
> is going quickly (without raid0) and when slowly (with raid0).
>
> Rather than tcpdump, it might be easier to instrument the nbd server
> to print out requests and timestamps.

Yes, it is good idea!
I will try it, thanks!

>
> Sorry I cannot be more helpful, and do have a Merry Christmas anyway
> :-)

The same to you, and everybody on this list! :-)

Cheers,
Janos

>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

