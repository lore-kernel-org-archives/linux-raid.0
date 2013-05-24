From: Drew <drew.kay@gmail.com>
Subject: Re: Moving RAID1 disks between systems
Date: Fri, 24 May 2013 11:30:05 -0700
Message-ID: <CACJz6Qt-zULSobEDqo306gow4wAvx1LQdXBf3K5XHm36rDKE4Q@mail.gmail.com>
References: <CAGPLN=s0nBeuHk75KSaKV2LS1MxYrdVmXjG7eM+dP36bOSbA-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGPLN=s0nBeuHk75KSaKV2LS1MxYrdVmXjG7eM+dP36bOSbA-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Santos <iluvgadgets@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jim,

You should have no troubles reassembling the array on a new machine.
From what I understand, md raid doesn't depend on device names for
assembling arrays, it has some internal UUID's to distinguish which
array a member disk belongs to.

mdadm --assemble --scan is pretty much all you need (and won't break
anything in the process)



-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
