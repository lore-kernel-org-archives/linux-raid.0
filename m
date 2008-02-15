From: "Shannon Nelson" <shannon.lee.nelson@gmail.com>
Subject: Re: [BUG] OOPS 2.6.24.2 raid5 write with ioatdma
Date: Fri, 15 Feb 2008 11:43:09 -0800
Message-ID: <3cce60f30802151143gc98e3a2l29aa49f8f829e2f6@mail.gmail.com>
References: <20080215171905.2e5c6bee@smartjog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080215171905.2e5c6bee@smartjog.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CORBES <laurent.corbes@smartjog.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, "Nelson, Shannon" <shannon.nelson@intel.com>
List-Id: linux-raid.ids

On Fri, Feb 15, 2008 at 8:19 AM, Laurent CORBES
<laurent.corbes@smartjog.com> wrote:
> Hi all,
>
>  I got a raid5 oops when trying to write on a raid 5 array, with ioatdma loaded
>  and without DCA activated in bios:
>
[...]

Dan's quick patch is likely the right answer.

>
>  When I enable DCA in system bios I cannot boot, the ioatdma subsystem failed to
>  initialize, it stalled at:
>  ioatdma: ioat_dma_test_callback(00008086)

I don't see this example in the dmesg, but I'm not sure why you think
this is the case.  If DCA is enabled, you should not see any further
messages from ioatdma after the ioat_self_test_callback().

sln
-- 
==============================================
Mr. Shannon Nelson Parents can't afford to be squeamish.
