From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Tue, 4 Jul 2006 00:46:03 +0200
Message-ID: <20060703224557.GB26362@percy.comedia.it>
References: <20060702224549.GD12733@percy.comedia.it> <17576.21342.685662.432117@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17576.21342.685662.432117@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 03, 2006 at 09:14:38AM +1000, Neil Brown wrote:
>However....
>
>> +
>> +	/* if we are using udev and auto is not set, mdadm will almost
>> +	 * certainly fail, so we force it here.
>> +	 */
>> +	if (autof == 0 && access("/dev/.udevdb",F_OK) == 0)
>> +		autof=2;
>> +
>
>I'm worried that this test is not very robust.
>On my Debian/unstable system running used, there is no
> /dev/.udevdb
>though there is a
> /dev/.udev/db
>
>I guess I could test for both, but then udev might change
>again.... I'd really like a more robust check.
>
is /dev/.udev/db a debianism?
in this case a check for both might suffice, else i will have to think
harder about it.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
