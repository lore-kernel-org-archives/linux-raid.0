From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: mdadm 3.0.3 bug report
Date: Mon, 9 Nov 2009 17:47:00 -0700
Message-ID: <e9c3a7c20911091647r4efae6ear9938cb3388775abe@mail.gmail.com>
References: <cccedfc60911090743m77b26b7bx98bf5d18b7e96311@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60911090743m77b26b7bx98bf5d18b7e96311@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 9, 2009 at 8:43 AM, Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:
> I tried to create a raid thusly:
> mdadm --create /dev/md3 --level=10 --layout=f2 --metadata=ddf
> --raid-devices=2 --assume-clean /dev/sdc1 missing
> and while I got a non-zero exit code (1), I did not get an error
> message or any other indication of failure.
>
> The misfeature is that I expected some sort of message.

Yes, there should be a message that points out that the external
metadata formats ('ddf' and 'imsm') require a container to be created
first and then raid volumes are carved out of that container.  The
mdmon man page has a little blurb on containers.  The 'missing' option
is currently not supported for creating containers so you would need
to modify this to something like:

mdadm --create /dev/md/ddf -e ddf /dev/sdc /dev/sdX -n 2
mdadm --create /dev/md/volume0 /dev/md/ddf --level=10 --layout=f2

--
Dan
