From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: RE: mdadm man page update proposed
Date: Fri, 16 Jan 2009 11:51:24 +0100
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B2A0E2BFB9A@SE-EX008.groupinfra.com>
References: <6121ee740901160136l43925896v42d1cd35ab5ab724@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6121ee740901160136l43925896v42d1cd35ab5ab724@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Attila Nagy <nagy.attila.gabor@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I believe it would be helpful to many to note in the mdadm manual
> page, that only version 0.90 superblocks can be auto-detected by
> current kernels.
>
> Nagy Attila Gabor

You know, I used 0.90 superblocks on CentOS 5.2 and they were recognized (ie assembled so that Cat/proc/mdstat saw the discs).

I just moved to Ubuntu with 2.6.27 and decided on 1.2 superblocks and they were auto assembled anyway.  Is this what we mean when we say "autodetected by the kernel" or have I misunderstood?

If im right then it doesn't seem to be an issue with later kernels.

--andrew
