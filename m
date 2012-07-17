From: Asdo <asdo@shiftmail.org>
Subject: Re: On mdadm 3.2 and bad-block-log
Date: Tue, 17 Jul 2012 10:21:45 +0200
Message-ID: <50052099.4000401@shiftmail.org>
References: <4FD7738D.3040403@shiftmail.org>
 <CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
 <20120716134138.0f1c9cfc@notabene.brown> <5003C5BC.3070609@shiftmail.org>
 <CAGRgLy6udWWhYn_UEwyyVrKsV5auAdfN5qkLVxbNnVqgWE=+UQ@mail.gmail.com>
 <5003D73B.3010609@shiftmail.org> <20120717114916.46263d92@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20120717114916.46263d92@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/17/12 03:49, NeilBrown wrote:
> On Mon, 16 Jul 2012 10:56:27 +0200 Asdo<asdo@shiftmail.org>  wrote:
>
> Yes, there is a degree to which your data is at risk. This is always 
> the case with new code. If you upgrade to new -stable kernels as they 
> become available, that should minimise your risk as any fix that could 
> risk data or stability is backported to these -stable kernels.

I am on kernel 3.4, that's "stable", right?

> I don't know of any particularly serious bugs that have been found - they
> mostly are triggered by unusual conditions.  However unusual conditions do
> happen.
>
> Thank you for using and testing the code.  Has md found and recorded any bad
> blocks for you, or are your bad-block logs still empty?

Still empty for now
They are filled only on read error + failed block rewrite, right? That 
will take a long time to happen...

Thanks for your work

