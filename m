From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: dmaengine: fix dependency chaining
Date: Mon, 12 Jan 2009 15:12:42 -0700
Message-ID: <e9c3a7c20901121412q1b4451acq5d04f19f422d110@mail.gmail.com>
References: <200901130022.50231.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200901130022.50231.yur@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, dzu@denx.de, wd@denx.de, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids

On Mon, Jan 12, 2009 at 2:22 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
> In dmaengine we track the dependencies between the descriptors
> using the 'next' pointers of the structure. These pointers are
> set to NULL as soon as the corresponding descriptor has been
> submitted to the channel (in dma_run_dependencies()).
>
> But, the first 'next' in chain is still remaining set, regardless
> the fact, that tx->next has been already submitted. This may lead to
> multiple submissions of the same descriptor. This patch fixes this.
>
> Actually, some previous implementation of the xxx_run_dependencies()
> function already had this fix in place. The fdb..0eaf3 commit, beside the
> correct things, broke this.
>
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>

Applied, thanks Yuri.

--
Dan
