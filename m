From: Derek Vadala <derek@cynicism.com>
Subject: Re: Creating degraded more arrays with mdadm?
Date: Sat, 14 Dec 2002 17:48:54 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021214224854.823333B808@jaded.cynicism.com>
References: <20021214222719.GA22527@willow.seitz.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021214222719.GA22527@willow.seitz.com>
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 14 Dec 2002, Ross Vandegrift wrote:

> 	I'm trying to convert to using mdadm for everything, but I
> couldn't really figure out how to do this.  I thought I figured it out
> with
>
> # mdadm --create /dev/md0 --level=1 --raid-disks=1 /dev/hde2
> ... copy data
> # mdadm --add /dev/md0 /dev/hdg2
>

Use the missing keyword in place of the device name:

# mdadm --create /dev/md0 --level=1 --raid-disks=2 /dev/hde2 missing

That should leave you with a 2-disk mirror with only /dev/hde2 as a
member.

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

