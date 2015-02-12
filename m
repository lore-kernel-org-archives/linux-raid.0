From: Roaming <antmbox@youngman.org.uk>
Subject: Re: please help - raid 1 degraded
Date: Thu, 12 Feb 2015 10:11:50 +0000
Message-ID: <54DC7C66.50709@youngman.org.uk>
References: <20150211180403.GA14805@fnord.prismnet.com> <54DBD3E2.80701@websitemanagers.com.au> <20150212000940.GA49579@eris.prismnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150212000940.GA49579@eris.prismnet.com>
Sender: linux-raid-owner@vger.kernel.org
To: sunruh@prismnet.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 12/02/2015 00:09, sunruh@prismnet.com wrote:
> i dont seem to be seeing the partition sizes or im stupid.
> couldnt i just dd if=/dev/sdb of=/dev/sdc bs=1G count=240 and then do the
> mdadm?
NOT a good idea. I don't know what it would do in your case, where you 
are using the entire disk, but if you're using a partition table you 
would suddenly end up with a bunch of duplicate GUIDs. Bearing in mind 
the "GU" stands for "globally unique", your management tools are likely 
to get confused ... not a good idea especially wrt raid.

Cheers,
Wol
