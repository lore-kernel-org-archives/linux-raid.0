From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [ LR] Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more
 than 120 seconds.
Date: Mon, 31 Oct 2016 19:29:35 +0000
Message-ID: <58179B9F.8090809@youngman.org.uk>
References: <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <73e35e17-80aa-c7e6-535c-3665d9789e16@mdevsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e35e17-80aa-c7e6-535c-3665d9789e16@mdevsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: TomK <tk@mdevsys.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/10/16 18:56, TomK wrote:
> 
> We did not do a thorough R/W test to see how the error and bad disk
> affected the data stored on the array but did notice pauses and
> slowdowns on the CIFS share presented from it with pauses and generally
> difficulty in reading data, however no data errors that we could see.
> Since then we replaced the 2TB Seagate with a new 2TB WD and everything
> is fine even if the array is degraded.  But as soon as we put in this
> bad disk, it degraded to it's previous behaviour.  Yet the array didn't
> catch it as a failed disk until the disk was nearly completely
> inaccessible.

What is this 2TB Seagate? A Barracuda? There's your problem, quite
possibly. Sounds like you've got your timeouts correctly matched, so
this drive is responding, but taking ages to do so. And that's why it
doesn't get kicked, but it knackers system response times - the kernel
is correctly configured to wait for the geriatric to respond.

Cheers,
Wol
