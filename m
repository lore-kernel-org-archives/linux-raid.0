From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: problems with lots of arrays
Date: Tue, 10 May 2016 16:48:01 -0400
Message-ID: <wrfj8tzhk5by.fsf@redhat.com>
References: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
	(Mike Lovell's message of "Thu, 5 May 2016 17:24:29 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Mike Lovell <mike.lovell@endurance.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Mike Lovell <mike.lovell@endurance.com> writes:
> we have a number of systems that have a large number of software
> arrays running. its in the couple hundred range. we have been using a
> custom built kernel based on 3.4 but are wanting to update to a
> mainline kernel and have been experimenting with 4.4. the systems are
> running recent centos 6 releases but we have been downgrading the
> mdadm version from 3.3.2 in 6.7 to a custom build 3.2.6. we installed
> the downgraded version due to a problem with array numbering. i
> emailed the list a while ago explaining the issue and submitting a
> patch to fix [1]. i never heard anything back and since we had a
> simple fix i didn't follow up on it.

[snip]

> what do you all think?
>
> thanks
> mike
>
> [1] http://marc.info/?l=linux-raid&m=142387809409798&w=2

Staying consistent in using dev_t rather than casting back and forth to
int seems a reasonable fix to apply to mdadm. It obviously won't change
the issues with the newer kernels, but I don't see any reason why we
shouldn't apply that fix to mdadm.

Neil any thoughts on this?

Cheers,
Jes
