From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH md] Fail safely when trying to grow an array with a write-intent bitmap.
Date: Tue, 5 Aug 2008 11:12:09 -0700
Message-ID: <e9c3a7c20808051112k7b0b23fdle1d52ccc4893f8dd@mail.gmail.com>
References: <1217917054-1725-1-git-send-email-neilb@suse.de>
	 <1217917054-1725-2-git-send-email-neilb@suse.de>
	 <1217917054-1725-3-git-send-email-neilb@suse.de>
	 <1217917054-1725-4-git-send-email-neilb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217917054-1725-4-git-send-email-neilb@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 4, 2008 at 11:17 PM, NeilBrown <neilb@suse.de> wrote:
> +               /* Sorry, cannot grow a bitmap yet, just remove it,
> +                * grow, and re-add.
> +                */

Perhaps this bit should be in a pr_info().

--
Dan
