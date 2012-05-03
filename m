From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Last call for input to mdadm-3.2.4
Date: Thu, 03 May 2012 11:18:03 +0200
Message-ID: <4FA24D4B.2080409@redhat.com>
References: <20120503142201.649766de@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120503142201.649766de@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Dan Williams <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>, Clint Byrum <clint@ubuntu.com>
List-Id: linux-raid.ids

On 05/03/12 06:22, NeilBrown wrote:
> Hi all,
>  I hope to release mdadm-3.2.4 next week.
> 
> This is mostly a bugfix release though there are a few small features
> like "--prefer=" which guides the selection of the device names reported by
> --detail and --monitor.
> It also now defaults /run/mdadm for runtime files rather than /dev/.mdadm or
> /var/run/mdadm.
> 
> I hope it will be just what I currently have in the 'master' branch of my git
> tree, plus changes to the version numbers.  However if anyone has anything
> that they really want to go in *now* I'm open to contributions if they are
> important.
> 
> I'll then try to focus more on preparing for 3.3 which will include:
>  - badblock log support
>  - hot-replace support
>  - raid10 reshape
> 
> and maybe other stuff.

Neil,

I just looked through my bug queue and I don't see anything that I am
desperate to have resolved before 3.2.4, so I am happy to see 3.2.4 fly.
Just did a giant bugfix backport for Fedora the last couple of days
which I would have skipped if I knew 3.2.4 which this close :)

Thanks for the heads up!

Jes

