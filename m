From: Jan Ceuleers <jan.ceuleers@gmail.com>
Subject: Re: Device Unusable At Startup
Date: Fri, 28 Sep 2012 13:11:02 +0200
Message-ID: <506585C6.10403@gmail.com>
References: <CACO8vipp6mWQCY-cWhSbty=XNKFoxc_q_ntv-0C+dKsRD8DEWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACO8vipp6mWQCY-cWhSbty=XNKFoxc_q_ntv-0C+dKsRD8DEWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Thomas <thomasj10@georgefox.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/28/2012 01:47 AM, Jake Thomas wrote:
> Note that all md devices must be stopped using a wildcard: "/dev/md*"
> because we technically don't know
> for sure what the name of the md device is that holds /usr. It could
> be /dev/md127, /dev/md126, /dev/md125
> or whatever. We simply don't know. If it's the only md device present,
> it will, with almost 100% certainty, be /dev/md127,
> but what if someone plugs in USB drives that have mdraid before you
> turn the computer on? Now we really don't know.
> Or, more likely, if you have more than one md raid array amongst your
> internal hard drives, we wouldn't know the name of the one we must
> stop to reassemble.
> 
> Unfortunately, /dev/disk/by-uuid is not populated for this md device,
> because it is currently broke. So we can't specify it by uuid
> or anything. A system-wide stopping of all md devices (/dev/md*) must
> be done to stop it.

Would it be a fair expectation for any non-borked arrays to be numbered
starting at /dev/md0 ? So that only the arrays numbered above 100 to be
likely borked?

If so you could try limiting the mdadm --stop to only /dev/md1[0-9][0-9]
or something like that.

HTH, Jan
