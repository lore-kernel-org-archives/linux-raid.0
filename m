From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: raid 4, and bitmap.
Date: Sat, 4 Feb 2006 12:19:44 +0100
Message-ID: <00b001c62987$290a4320$9d00a8c0@dcccs>
References: <04c201c62855$5efda450$9d00a8c0@dcccs><17378.40767.339455.85486@cse.unsw.edu.au><04d701c62857$9eb02e90$9d00a8c0@dcccs> <17378.41629.709430.775224@cse.unsw.edu.au> <04f401c62859$407f6910$9d00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Ahh, i almost forget!
> The mdadm is sometimes drop "cannot allocate memory" and next try
"segfault"
> when i try -G --bitmap=internal on 2TB arrays!
> And after segfault, the full raid is stops...
>
> Cheers,
> Janos

I think i found the bug, its me. :-)

Today it happens again, and i see, i have misstyped the "internal" word like
"intarnal".
The mdadm is accepted that, and try to make the bitmap on NFS again, and
crashed the raid.

I think it is neccessary to better test:

- the bitmap file's fs
- the filename itself.
(i mean did not allow the current directory, or the internal and none to be
a separated option)

Cheers,
Janos

