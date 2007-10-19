From: Iustin Pop <iusty@k1024.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 23:23:03 +0200
Message-ID: <20071019212303.GB2013@teal.hq.k1024.org>
References: <18200.49267.763509.924873@stoffel.org> <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan> <18200.53593.687483.120827@stoffel.org> <1192810534.1666.68.camel@firewall.xsintricity.com> <18200.56684.14194.630264@stoffel.org> <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18200.63987.514073.184865@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 19, 2007 at 02:39:47PM -0400, John Stoffel wrote:
> And if putting the superblock at the end is problematic, why is it the
> default?  Shouldn't version 1.1 be the default?  

In my opinion, having the superblock *only* at the end (e.g. the 0.90
format) is the best option.

It allows one to mount the disk separately (in case of RAID 1), if the
MD superblock is corrupt or you just want to get easily at the raw data.

As to the people who complained exactly because of this feature, LVM has
two mechanisms to protect from accessing PVs on the raw disks (the
ignore raid components option and the filter - I always set filters when
using LVM ontop of MD).

regards,
iustin
