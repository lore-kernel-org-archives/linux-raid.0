From: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Subject: Re: "mdadm --remove" fails if it is too soon after "mdadm --fail"
Date: Wed, 14 Oct 2009 12:38:24 -0600 (MDT)
Message-ID: <alpine.DEB.1.00.0910141236260.14710@darius>
References: <alpine.DEB.1.00.0910131748110.8815@darius>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0910131748110.8815@darius>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 14 Oct 2009, Darius S. Naqvi wrote:

> I.e., it seems that the ioctl invoked by --fail doesn't directly set
> up the device to be ready for --remove, but some other kernel thread
> completes that state change.  I'm wondering if it could be the case
> that when the system is very, very busy, it could take long enough for
> that kernel thread to run that it would cause what I see, i.e.,
> --remove fails with EBUSY, even though I've already waited about 20
> seconds for the device to be ready to be removed.  If this is so, what
> shall I do?  Here are the options I can think of:

Sorry to reply to my own posting.  It turns out that in this case,
I've only waited 2.5 seconds.  This may affect the probability of my
hunch being correct.

-- 
Darius S. Naqvi
dnaqvi@datagardens.com
http://www.datagardens.com
