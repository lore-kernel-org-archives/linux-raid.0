From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: RAID1: deadlock between freeze_array and blk plug?
Date: Mon, 13 Jun 2016 14:02:38 +0300
Message-ID: <CAGRgLy52+zCq8iA98g2bVf6yKV7YJ8kfWRnX_D-uZc2pYnOiGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Jes Sorensen <jes.sorensen@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil, Jes,

I wonder if the following deadlock is possible:

- Caller calls blk_start_plug and wants to submit two WRITE bios

- First bio successfully calls wait_barrier() and is appended to
plug->pending list

- Now somebody does freeze_array()

- freeze_array() unconditionally sets:
   conf->array_frozen = 1;
   and starts waiting for conf->nr_pending to go down

- Second WRITE bio calls wait_barrier, but it will wait for
"!conf->array_frozen" until it can proceed

- Now we have a deadlock: first bio will not be submitted because it
sits on the plug list of the caller, and caller is stuck in
wait_barrier, so it cannot do blk_finish_plug.

I am about to try to reproduce it on kernel 3.18, but looking at the
latest Linus tree, I don't see something preventing this from
happening either. Am I missing something?

Thanks,
Alex.
