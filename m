From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 14:29:12 +0200
Message-ID: <46A0AA98.5060901@gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de> <200707201522.17270.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759109AbXGTMai@vger.kernel.org>
In-Reply-To: <200707201522.17270.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2007 02:22 PM, Al Boldi wrote:

> Oh, gpart is great, but if we had a backup copy of the partition table on
> every partition location on disk, then this backup copy could easily be
> reused to reconstruct the original partition table without further 
> searching.

As long as you don't reboot you have a "backup copy" in kernel. Admittedly 
not in a very nice format, but /sys/block/<disk>/<part>/start and size have 
saved my butt a few times...

Rene.
