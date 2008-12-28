From: "Erik Boettcher" <tehfoo@gmail.com>
Subject: Re: Raid 5 Recovery
Date: Sun, 28 Dec 2008 13:13:15 -0500
Message-ID: <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
	 <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com>
	 <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com>
	 <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

---------- Forwarded message ----------
From: Erik Boettcher <tehfoo@gmail.com>
Date: Sun, Dec 28, 2008 at 1:04 PM
Subject: Re: Raid 5 Recovery
To: Dylan Distasio <interzone@gmail.com>


On Sun, Dec 28, 2008 at 1:02 PM, Erik Boettcher <tehfoo@gmail.com> wrote:
> On Sun, Dec 28, 2008 at 10:53 AM, Dylan Distasio <interzone@gmail.com> wrote:
>> Have you tried assembling the array degraded to see if you can force
>> it without sdd3?  I don't know if this is the best solution, but if
>> that works, you can then readd sdd3 and have the array rebuild.
>
> I tried forcing the assembly without sdd3, and it complains about sde3!
>
> I find it interesting that before the first command sdc3 failed but
> now it's not the fault point....
>

I guess I should specify how it complains: the exact same error
message but sde3 instead.

mack ~ # mdadm -A --force --no-degraded /dev/md0 /dev/sd{a,b,c,e}3
mdadm: superblock on /dev/sde3 doesn't match others - assembly aborted

eek, and I tried with the first 3 hdds and got this:
mack ~ # mdadm -A --force --no-degraded /dev/md0 /dev/sd{a,b,c}3
mdadm: clearing FAULTY flag for device 2 in /dev/md0 for /dev/sdc3
mdadm: clearing FAULTY flag for device 1 in /dev/md0 for /dev/sdb3
mdadm: clearing FAULTY flag for device 0 in /dev/md0 for /dev/sda3
mdadm: failed to add /dev/sdb3 to /dev/md0: Invalid argument
mdadm: failed to add /dev/sda3 to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdc3 to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives (out of 5), but not started.
