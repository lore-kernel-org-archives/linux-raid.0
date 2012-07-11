From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: On mdadm 3.2 and bad-block-log
Date: Wed, 11 Jul 2012 12:40:57 +0300
Message-ID: <CAGRgLy5Eryf_kT69a3SSPi8-MVpVmhEL96tNWJZQd9-vf4iYZQ@mail.gmail.com>
References: <4FD7738D.3040403@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD7738D.3040403@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Asdo <asdo@shiftmail.org>
List-Id: linux-raid.ids

Hi Neil,
can you pls clarify whether the bad block management code in existing
kernels is still considered experimental, and that's the reason there
is no mdadm 3.3.x release yet?
If yes, which kernel do you recommend to experiment with this feature?
If no, should we then use the "devel-3.3" branch of mdadm, which was
last updated ~1 year ago?

Thanks,
Alex.



On Tue, Jun 12, 2012 at 7:51 PM, Asdo <asdo@shiftmail.org> wrote:
> Hello
> is it possible to keep mdadm 3.2 installed in the system (e.g. 3.2 as the
> monitoring daemon) and have an array with bad-block functionality (created
> with 3.3) running, or this will do a mess?
>
> Bad-block functionality is in mdadm-3.3 but this has not been released yet.
> I was thinking about using it only once to create the array.
>
> However I am still missing the manual for mdadm-3.3, where is that? without
> that I don't know how I should launch it to create an array with bad blocks.
>
> Another question: are older kernels such as 3.0 capable to run an array
> created with bad-block-log, obviously without using the bad-block-log
> functionality? oh but that could be dangerous, couldn't it...
>
> Thank you
> A.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
