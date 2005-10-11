From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 002 of 5] Extend md sysfs support to component
 devices.
Date: Tue, 11 Oct 2005 16:51:40 -0700
Message-ID: <20051011165140.46c8114d.akpm@osdl.org>
References: <20051004151922.28715.patches@notabene>
	<1051004052327.28800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051004052327.28800@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +				if (rdev2->raid_disk >= 0) {
> +					char nm[20];

fyi, the two instances of nm[] in this function will consume 40 bytes of
stack (gcc is lame).  If you were to put a single nm[20] at the outermost
level of the function and then use it in both places, only 20 bytes of
stack would be used.
