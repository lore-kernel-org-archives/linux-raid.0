From: Drew <drew.kay@gmail.com>
Subject: Re: "Missing" RAID devices
Date: Tue, 21 May 2013 10:03:56 -0700
Message-ID: <CACJz6Qvpf9yTzHTE6f5pErny1DLh7BvV3S+Q-Ekbb_-CEtKW1w@mail.gmail.com>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
 <519B9F8C.3080104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519B9F8C.3080104@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Santos <iluvgadgets@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jim,

The other question I'd ask is why do you have 10 raid1 arrays on those
two disks?

Given you have an initramfs, at most you should have separate
partitions (raid'd) for /boot & root. Everything else should be broken
down using LVM. Way more flexible to move things around in future as
required.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
