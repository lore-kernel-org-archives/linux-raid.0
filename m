From: Neil Brown <neilb@suse.de>
Subject: Re: import existing intel array
Date: Thu, 4 Jun 2009 08:43:38 +1000
Message-ID: <18982.64666.532101.651635@notabene.brown>
References: <20090603143038.GA11045@mrq1.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hermann Gausterer on Wednesday June 3
Sender: linux-raid-owner@vger.kernel.org
To: Hermann Gausterer <nail-brown-mdadm-question@mrq1.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 3, nail-brown-mdadm-question@mrq1.org wrote:
> hi neil

Hi.
 I've taken the liberty of adding Cc: to linux-raid@vger.kernel.org

> 
> your mdadm 3.0 release is great work!

Thanks.

> 
> what are the commands for accessing a existing
> (windows created) intel ichX raid array?
> 
> i think this is a common use case ..
> 
> can you help me?

I would start with

# mdadm -Es

which should show something vaguely like:

ARRAY metadata=imsm auto=md UUID=8a73e835:3019890d:4f976c0c:eafd8c7e
ARRAY /dev/md/r1 container=8a73e835:3019890d:4f976c0c:eafd8c7e
   member=0 UUID=bede01d9:b40a5dbc:ea37b919:68a0005c

That confirms that there is an imsm array there.  In my case there is
one member array in the container - it is called 'r1'.

Now you can assemble the container using:

# mdadm -A /dev/md/imsm0 --uuid=8a73e835:3019890d:4f976c0c:eafd8c7e

and then assemble all the arrays in the container using

# mdadm -I /dev/md/imsm0

If you are happy with this, you can put the output of "-Es" in
mdadm.conf and them
# mdadm -As

should assemble it all automatically.

Please report any interesting experiences.

Thanks,
NeilBrown
