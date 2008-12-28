From: "NeilBrown" <neilb@suse.de>
Subject: Re: Raid 5 Recovery
Date: Mon, 29 Dec 2008 08:31:13 +1100 (EST)
Message-ID: <0751481ab32bd9084154902b6ca31e9f.squirrel@neil.brown.name>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
    <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com>
    <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com>
    <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com>
    <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Boettcher <tehfoo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, December 29, 2008 5:13 am, Erik Boettcher wrote:
> ---------- Forwarded message ----------
> From: Erik Boettcher <tehfoo@gmail.com>
> Date: Sun, Dec 28, 2008 at 1:04 PM
> Subject: Re: Raid 5 Recovery
> To: Dylan Distasio <interzone@gmail.com>
>
>
> On Sun, Dec 28, 2008 at 1:02 PM, Erik Boettcher <tehfoo@gmail.com> wrote:
>> On Sun, Dec 28, 2008 at 10:53 AM, Dylan Distasio <interzone@gmail.com>
>> wrote:
>>> Have you tried assembling the array degraded to see if you can force
>>> it without sdd3?  I don't know if this is the best solution, but if
>>> that works, you can then readd sdd3 and have the array rebuild.
>>
>> I tried forcing the assembly without sdd3, and it complains about sde3!
>>
>> I find it interesting that before the first command sdc3 failed but
>> now it's not the fault point....
>>
>
> I guess I should specify how it complains: the exact same error
> message but sde3 instead.

Yes, specifics are good.  I'm afraid I need a few more though.
  mdadm -Esvvv
and
  dmesg | tail -20

after the failed --assemble attempt would be a good start.

NeilBrown


>
> mack ~ # mdadm -A --force --no-degraded /dev/md0 /dev/sd{a,b,c,e}3
> mdadm: superblock on /dev/sde3 doesn't match others - assembly aborted
>
> eek, and I tried with the first 3 hdds and got this:
> mack ~ # mdadm -A --force --no-degraded /dev/md0 /dev/sd{a,b,c}3
> mdadm: clearing FAULTY flag for device 2 in /dev/md0 for /dev/sdc3
> mdadm: clearing FAULTY flag for device 1 in /dev/md0 for /dev/sdb3
> mdadm: clearing FAULTY flag for device 0 in /dev/md0 for /dev/sda3
> mdadm: failed to add /dev/sdb3 to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sda3 to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdc3 to /dev/md0: Invalid argument
> mdadm: /dev/md0 assembled from 0 drives (out of 5), but not started.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

