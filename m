From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 013 of 20] Count corrected read errors per drive.
Date: Mon, 12 Dec 2005 02:07:15 -0800
Message-ID: <20051212020715.58869140.akpm@osdl.org>
References: <20051212135705.4561.patches@notabene>
	<1051212031519.5128@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051212031519.5128@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +      errors
>  +        An approximate count of read errors that have been detected on
>  +        this device but have not caused the device to be evicted from
>  +        the array (either because they were corrected or because they
>  +	happened while the array was read-only).  When using version-1
>  +	metadata, this value persists across restarts of the array.

Looks funny.  Mixture of tabs and spaces I guess.

<fixes it>
