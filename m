From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Tue, 5 Dec 2017 10:56:20 +0000
Message-ID: <5A267B54.7070408@youngman.org.uk>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Graham <jeremy@doghouse.agency>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/12/17 09:41, Jeremy Graham wrote:
> $ mdadm --version
> mdadm - v3.4 - 28th January 2016

Won't do any harm to try the latest version, but this could well be the
problem.

https://raid.wiki.kernel.org/index.php/Linux_Raid

That'll tell you where to download the latest mdadm from. This sounds a
typical problem that people have had, and iirc upgrading mdadm often
fixes it.

Let us know what the latest mdadm does, and if it doesn't fix it,
someone else will be along with more advice.

Cheers,
Wol
