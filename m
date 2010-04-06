From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch mdadm] Fix ppc compile error
Date: Wed, 7 Apr 2010 09:22:37 +1000
Message-ID: <20100407092237.5affe057@notabene.brown>
References: <4BBB7962.7040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBB7962.7040403@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, 06 Apr 2010 14:11:46 -0400
Doug Ledford <dledford@redhat.com> wrote:

> We use -Wall -Werror on our build machines, and this causes our build to
> fail on super-intel.c due to a missing cast on ppc64 machines.  This
> fixes the build.
> 

Thanks.  Applied.

NeilBrown
