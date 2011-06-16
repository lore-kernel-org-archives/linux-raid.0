From: NeilBrown <neilb@suse.de>
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Thu, 16 Jun 2011 10:18:12 +1000
Message-ID: <20110616101812.761f7397@notabene.brown>
References: <1307840471.18429.1462140465@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307840471.18429.1462140465@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeffs_linux@123mail.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 11 Jun 2011 18:01:11 -0700 jeffs_linux@123mail.org wrote:

> Hi,
> 
> I'm working on setting up my 1st Linux production server with RAID for
> our office.

---- cut lots of detail-----
It is very good to include lots of detail, but more effective you include it
after you have asked the question, otherwise one gets bored long before one
reaches the actual question....

> 
> 
> Now, I'm going about characterizing the arrays, and the Volumes on them,
> so I can deal with recovery if & when it's necessary.
> 
> When I "look" at the array with these two commands,
> 
> mdadm --examine --scan
> 	ARRAY /dev/md/jeffadm1 metadata=1.2
> 	UUID=d84afb64:e6fa2b64:ff21c975:f9765431 name=jeffadm:jeffadm1
> 	ARRAY /dev/md126 UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e
> 
> mdadm --detail --scan
> 	ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
> 	UUID=d84afb64:e6fa2b64:ff21c975:f9765431
> 	ARRAY /dev/md/0_0 metadata=0.90
> 	UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e
> 
> 
> I get different results for each one.

It is just the different names that has you bothered - correct?

Names are messy things.  We pretend that everything has just one name but
that isn't really true (reminds me of "The Traveller in Black" ... he had
many names but one nature.  But I digress).

In the two different cases the 'name' of the array is found in different ways.
Both are correct, they are just different.

So unless there is some real confusion being caused, best just to move on and
not let it worry you..

NeilBrown



> 
> >From my reading about naming in mdadm.conf, I was expecting to see:
> 
>   /dev/md/0_0
>   /dev/jeffadm:jeffadm1
> 
> 
> Why do I get this mix of different results,
> 
> 	/dev/md/jeffadm1
> 	/dev/md126
> 
> from the "--detail" output, and
> 
> 	/dev/md127 metadata=1.2 name=jeffadm:jeffadm1
> 	/dev/md/0_0
> 
> according to the "--examine" output?
> 
> Is my mdadm.conf OK?  What really should I expect to see for the names
> of my arrays?
> 
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

