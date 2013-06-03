From: Chris Finley <debenbain@gmail.com>
Subject: Re: Wiki-recovering failed raid, overlay problem
Date: Mon, 3 Jun 2013 16:35:14 -0700
Message-ID: <CAGXrYFSiYMDpeTESv_-aA7QsbV0gYnr1seUHWZuS1bWwABk5Pg@mail.gmail.com>
References: <CAGXrYFTamGFyiOz34ZV+zaoXMA3D9z-eJjco3gApdK95QR9fPg@mail.gmail.com>
	<51AA83FD.8080500@turmel.org>
	<CAGXrYFSgoLpKO-UHd_tvOh3gs3Ub2qqOKA48kPEA1Pr=cnrUhA@mail.gmail.com>
	<51AAA0B9.3050908@turmel.org>
	<CAGXrYFTyzG-hakGrU9j1=TSmjZHbzs2aRypJX=w8O4viS1+Dfg@mail.gmail.com>
	<51AB4E5C.5060909@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AB4E5C.5060909@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 2, 2013 at 6:53 AM, Phil Turmel <philip@turmel.org> wrote:
[trim /]
>
> There are numerous discussions in the archives...  search them for
> combinations of "scterc", "tler", and "ure".
>
It appears this has been a frequent issue over the last year. Thank
you for the background information, I understand what I was reading.

>
> So your device role order is /dev/sd{c,b,d,e}1.

[trim /]

> Anyways, the quickest way for you to have a running array is to use
> "mdadm --assemble --force /dev/md0 /dev/sd{c,b,e}1".  This leaves out
> the first dropped disk.  Any remaining UREs cannot be corrected while
> degraded, but the data on the first dropped disk is suspect.
>
> Feel free to use an overlay on /dev/md0 itself while making your first
> attempt to mount and access the data.  If you cannot get critical data,
> stop and re-assemble with all four devices.
>
> Phil
>
Thanks, I will do that.

I am correct in thinking that I should not set scterc to 7 seconds
initially, since there will not be any parity to correct the read
errors? Best would be to set the driver time-out to 180 seconds until
after the array is rebuilt?

I am concerned about read errors during the rebuild. With a failed and
rebuilding array, will the get drive kicked on an URE? Is it better to
use something like badblocks or dd_rescue to correct/mark the sectors
first and then rebuild? Either way, I'm going to lose that data, but
maybe there are some better tools for extracting data from a bad
sector?

After the rebuild is complete, I should set the scterc to 7 seconds
and add a bitmap based write-intent log?

Does anyone learn these things the easy way :)

Much appreciated, Chris
