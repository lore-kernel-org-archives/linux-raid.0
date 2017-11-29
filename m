From: Chris Murphy <lists@colorremedies.com>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 15:27:49 -0700
Message-ID: <CAJCQCtTTRcR-2TsS8YHDVQvVzYCR0G5dYTv8bB2RwWEk-gTxuw@mail.gmail.com>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net> <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
 <CAJCQCtRdXJkaLdzDi4JuDJbjkSqX-mUj+kjrHtH6JNTLCenuuQ@mail.gmail.com> <CAJH6TXjF+vuBwGboM8HVMa88bZdn=GhgTumwJXH6qOZUso_Sjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXjF+vuBwGboM8HVMa88bZdn=GhgTumwJXH6qOZUso_Sjw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 29, 2017 at 3:14 PM, Gandalf Corvotempesta
<gandalf.corvotempesta@gmail.com> wrote:

>
> So, if you where me, how many gpt partition and which types would you make ?

What's the complete use case scenario? I can't really tell from the first post.

What I do is use gdisk type code 8300 (generic linux partition), and
then format that partition as LUKS1. And then I open the LUKS device
and make it a PV, create VG, and do that on every physical device.

Now you can make however many LV's you want, any size you want, in
arbitrary order, with whatever raid level you want. LVM's
raid0,1,10,5,6 use the md driver in the kernel, same as mdadm, but
it's LVM metadata which means everything is managed with LVM (disk
replacement and so forth). And there are still features mdadm has that
LVM raid does not implement. So you it's not a question of which is
better overall, it's a question of which one fits your use case best,
and the tools with which you're most familiar.

But it's pretty neat to be able to have one big VG, and to be able to
arbitrarily create LV's that themselves have the raid type. It's a lot
easier to manage in the case where you need different levels of
redundancy but you're not completely certain what the utilization of
those volumes will be, you can leave some unallocated space in the VG
"pool" so you can increase the size of any LV on demand whenever you
want.

If you're more comfortable with a conventional approach: GPT > LUKS >
mdadm > LVM > file system is just fine. I pretty much always start out
with LUKS for data drives because it's the only way to be certain
you're not leaking data should the drive need to be repurposed or
returned under warranty and won't spin up. It's also too easy to just
luksErase or luksFormat to obliterate everything on the drive, rather
than have to do a complete tear down of each layer's signature, and
you really shouldn't leave stale storage stack layers behind when
repurposing drives, it can cause confusion later.

-- 
Chris Murphy
